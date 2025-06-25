const mysql = require('mysql2/promise');

const shard1 = await mysql.createConnection({
  host: 'localhost',
  port: 3308,
  user: 'root',
  password: 'wendy0511',
  database: 'pokemon_shard1'
});

const shard2 = await mysql.createConnection({
  host: 'localhost',
  port: 3309,
  user: 'root',
  password: 'wendy0511',
  database: 'pokemon_shard2'
});

/*Selecciona el shard segun su region */
function getShardByRegion(region) {
  if (region === 'norte') return shard1;
  if (region === 'sur') return shard2;

  /*EN caso de que sea una region desconocida*/
  const random = Math.random();
  console.warn(`⚠️ Región desconocida: "${region}". Enrutando aleatoriamente a un shard.`);
  return random < 0.5 ? shard1 : shard2;
}

/* Inserta la transaccion en el shard correcto*/
async function insertTransaction(id_trainer, region, amount) {
  const db = getShardByRegion(region);
  await db.execute(
    'INSERT INTO transactions (id_trainer, region, amount) VALUES (?, ?, ?)',
    [id_trainer, region, amount]
  );
  console.log(`✅ Transacción insertada en shard de región: ${region}`);
}

/* inserta dos transacciones en diferentes shards */
async function run() {
  await insertTransaction(101, 'norte', 999.99);
  await insertTransaction(202, 'sur', 888.88);
  process.exit(0);
}

run().catch(console.error);
