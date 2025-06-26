import pg from 'pg';
const { Client } = pg;

const pgConfig = {
  host: 'postgres_master',
  user: 'postgres',
  password: 'masterpass',
  database: 'pokemon_db',
  port: 5432,
};

async function runETL() {
  const pgClient = new Client(pgConfig);

  try {
    await pgClient.connect();
    console.log("⏳ Creando esquema estrella...");

    // Crear esquema y tablas
    await pgClient.query(`
      DROP SCHEMA IF EXISTS dw CASCADE;
      CREATE SCHEMA dw;

      CREATE TABLE dw.dim_date (
        id SERIAL PRIMARY KEY,
        date DATE NOT NULL,
        month INT NOT NULL,
        year INT NOT NULL,
        UNIQUE (date)
      );

      CREATE TABLE dw.dim_trainer (
        id SERIAL PRIMARY KEY,
        trainer_id INT NOT NULL UNIQUE,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100)
      );

      CREATE TABLE dw.dim_transaction_type (
        id SERIAL PRIMARY KEY,
        transaction_type VARCHAR(50) NOT NULL UNIQUE
      );

      CREATE TABLE dw.fact_transactions (
        id SERIAL PRIMARY KEY,
        trainer_id INT REFERENCES dw.dim_trainer(id),
        date_id INT REFERENCES dw.dim_date(id),
        transaction_type_id INT REFERENCES dw.dim_transaction_type(id),
        amount DECIMAL(10, 2) NOT NULL,
        UNIQUE (trainer_id, date_id, transaction_type_id)
      );
    `);

    console.log("📥 Extrayendo datos...");

    // Extraer datos de transactions y trainers
    const result = await pgClient.query(`
      SELECT t.id_transaction, t.id_trainer, t.transaction_type, t.amount, t.status, t.created_at,
             tr.name AS trainer_name, tr.email
      FROM transactions t
      JOIN trainers tr ON t.id_trainer = tr.id_trainer
    `);

    const transactions = result.rows;
    const dateMap = new Map();
    const trainerMap = new Map();
    const transactionTypeMap = new Map();

    // Transformar y cargar datos
    for (const tx of transactions) {
      const dateKey = tx.created_at.toISOString().split('T')[0];
      if (!dateMap.has(dateKey)) {
        const res = await pgClient.query(
          `INSERT INTO dw.dim_date (date, month, year) 
           VALUES ($1, $2, $3) 
           ON CONFLICT (date) DO NOTHING 
           RETURNING id`,
          [tx.created_at, tx.created_at.getMonth() + 1, tx.created_at.getFullYear()]
        );
        if (res.rowCount > 0) {
          dateMap.set(dateKey, res.rows[0].id);
        } else {
          const existing = await pgClient.query(
            `SELECT id FROM dw.dim_date WHERE date = $1`,
            [tx.created_at]
          );
          dateMap.set(dateKey, existing.rows[0].id);
        }
      }

      if (!trainerMap.has(tx.id_trainer)) {
        const res = await pgClient.query(
          `INSERT INTO dw.dim_trainer (trainer_id, name, email) 
           VALUES ($1, $2, $3) 
           ON CONFLICT (trainer_id) DO NOTHING 
           RETURNING id`,
          [tx.id_trainer, tx.trainer_name, tx.email]
        );
        if (res.rowCount > 0) {
          trainerMap.set(tx.id_trainer, res.rows[0].id);
        } else {
          const existing = await pgClient.query(
            `SELECT id FROM dw.dim_trainer WHERE trainer_id = $1`,
            [tx.id_trainer]
          );
          trainerMap.set(tx.id_trainer, existing.rows[0].id);
        }
      }

      if (!transactionTypeMap.has(tx.transaction_type)) {
        const res = await pgClient.query(
          `INSERT INTO dw.dim_transaction_type (transaction_type) 
           VALUES ($1) 
           ON CONFLICT (transaction_type) DO NOTHING 
           RETURNING id`,
          [tx.transaction_type]
        );
        if (res.rowCount > 0) {
          transactionTypeMap.set(tx.transaction_type, res.rows[0].id);
        } else {
          const existing = await pgClient.query(
            `SELECT id FROM dw.dim_transaction_type WHERE transaction_type = $1`,
            [tx.transaction_type]
          );
          transactionTypeMap.set(tx.transaction_type, existing.rows[0].id);
        }
      }

      await pgClient.query(
        `INSERT INTO dw.fact_transactions (trainer_id, date_id, transaction_type_id, amount) 
         VALUES ($1, $2, $3, $4) 
         ON CONFLICT (trainer_id, date_id, transaction_type_id) DO NOTHING`,
        [
          trainerMap.get(tx.id_trainer),
          dateMap.get(dateKey),
          transactionTypeMap.get(tx.transaction_type),
          tx.amount,
        ]
      );
    }

    console.log("✅ ETL ejecutado correctamente");
  } catch (error) {
    console.error("Error durante el ETL:", error);
  } finally {
    await pgClient.end();
  }
}

runETL();