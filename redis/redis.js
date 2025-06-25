const redis = require('redis');
const mysql = require('mysql2/promise');

const redisClient = redis.createClient({
  url: 'redis://localhost:6379'
});

async function init() {
  await redisClient.connect();
}

const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: 'wendy0511',
  database: 'pokemon_db'
};

let db;
async function getDbConnection() {
  if (!db) {
    db = await mysql.createConnection(dbConfig);
  }
  return db;
}

// 1) Transacciones (saldo de monedas o logs financieros) TTL 5 minutos
async function getTrainerCoins(id_trainer) {
  const cacheKey = `trainer:${id_trainer}:poke_coins`;
  const cached = await redisClient.get(cacheKey);
  if (cached) {
    console.log('✅ Cache hit - Trainer Coins');
    return parseFloat(cached);
  }

  console.log('❌ Cache miss - Trainer Coins. Querying MySQL...');
  const db = await getDbConnection();
  const [rows] = await db.execute(
    `SELECT IFNULL(SUM(amount), 0) AS coins 
     FROM transactions 
     WHERE id_trainer = ? AND status = 'completed'`,
    [id_trainer]
  );

  const coins = rows.length > 0 ? rows[0].coins : 0;
  await redisClient.setEx(cacheKey, 300, coins.toString()); // TTL 5 min
  return coins;
}

// 2) Logs JSON (ej: logs de eventos o acciones) TTL 10 minutos
async function getLogsByType(log_type) {
  const cacheKey = `logs:${log_type}`;
  const cached = await redisClient.get(cacheKey);
  if (cached) {
    console.log('✅ Cache hit - Logs JSON');
    return JSON.parse(cached);
  }

  console.log('❌ Cache miss - Logs JSON. Querying MySQL...');
  const db = await getDbConnection();
  const [rows] = await db.execute(
    `SELECT data, created_at FROM logs_json WHERE log_type = ? ORDER BY created_at DESC LIMIT 50`,
    [log_type]
  );

  await redisClient.setEx(cacheKey, 600, JSON.stringify(rows)); // TTL 10 min
  return rows;
}

// 3) Historial de batalla (battle_history) TTL 15 minutos
async function getBattleHistory(id_battle) {
  const cacheKey = `battle:${id_battle}:history`;
  const cached = await redisClient.get(cacheKey);
  if (cached) {
    console.log('✅ Cache hit - Battle History');
    return JSON.parse(cached);
  }

  console.log('❌ Cache miss - Battle History. Querying MySQL...');
  const db = await getDbConnection();
  const [rows] = await db.execute(
    `SELECT history FROM battle_history WHERE id = ?`,
    [id_battle]
  );

  if (rows.length > 0) {
    await redisClient.setEx(cacheKey, 900, rows[0].history); // TTL 15 min
    return JSON.parse(rows[0].history);
  }
  return null;
}

// 4) Items activos de entrenador 30 minutos
async function getActiveItems(id_trainer) {
  const cacheKey = `trainer:${id_trainer}:active_items`;
  const cached = await redisClient.get(cacheKey);
  if (cached) {
    console.log('✅ Cache hit - Active Items');
    return JSON.parse(cached);
  }

  console.log('❌ Cache miss - Active Items. Querying MySQL...');
  const db = await getDbConnection();
  const [rows] = await db.execute(
    `SELECT id_item, item_type, details, acquired_at FROM items WHERE id_trainer = ? AND active = 1`,
    [id_trainer]
  );

  await redisClient.setEx(cacheKey, 1800, JSON.stringify(rows)); // TTL 30 min
  return rows;
}

// 5) Comentarios en batalla (battle_comments) TTL 15 minutos
async function getBattleComments(id_battle) {
  const cacheKey = `battle:${id_battle}:comments`;
  const cached = await redisClient.get(cacheKey);
  if (cached) {
    console.log('✅ Cache hit - Battle Comments');
    return JSON.parse(cached);
  }

  console.log('❌ Cache miss - Battle Comments. Querying MySQL...');
  const db = await getDbConnection();
  const [rows] = await db.execute(
    `SELECT id_trainer, comment, created_at FROM battle_comments WHERE id_battle = ? ORDER BY created_at ASC`,
    [id_battle]
  );

  await redisClient.setEx(cacheKey, 900, JSON.stringify(rows)); // TTL 15 min
  return rows;
}

// 6) Movimientos de batalla (moves) TTL 15 minutos
async function getBattleMoves(id_battle) {
  const cacheKey = `battle:${id_battle}:moves`;
  const cached = await redisClient.get(cacheKey);
  if (cached) {
    console.log('✅ Cache hit - Battle Moves');
    return JSON.parse(cached);
  }

  console.log('❌ Cache miss - Battle Moves. Querying MySQL...');
  const db = await getDbConnection();
  const [rows] = await db.execute(
    `SELECT id_move, move_name, power, status, created_at FROM moves WHERE id_battle = ? AND status = 1`,
    [id_battle]
  );

  await redisClient.setEx(cacheKey, 900, JSON.stringify(rows)); // TTL 15 min
  return rows;
}

async function invalidateCache(key) {
  await redisClient.del(key);
  console.log(`🗑️ Cache invalidated for key: ${key}`);
}

module.exports = {
  init,
  getTrainerCoins,
  getLogsByType,
  getBattleHistory,
  getActiveItems,
  getBattleComments,
  getBattleMoves,
  invalidateCache,
};
