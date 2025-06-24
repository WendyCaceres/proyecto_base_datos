-- 1. Optimization analysis for vista_insignias_activas
EXPLAIN
SELECT * FROM vista_insignias_activas LIMIT 10;
-- 2. Optimization analysis for vista_top_entrenadores_insignias
EXPLAIN
SELECT * FROM vista_top_entrenadores_insignias LIMIT 10;
-- 3. Optimization analysis for vista_batallas_finalizadas
EXPLAIN
SELECT * FROM vista_batallas_finalizadas LIMIT 10;
-- 4. Additional query: Transactions by trainer
EXPLAIN
SELECT 
    t.id_transaction,
    tr.name AS nombre_entrenador,
    t.transaction_type,
    t.amount,
    t.status
FROM transactions t
JOIN trainers tr ON t.id_trainer = tr.id_trainer
WHERE t.id_trainer = 1 AND t.status = 'Completed'
LIMIT 10;
-- 5. Additional query: Top trainers by transaction amount
EXPLAIN
SELECT 
    t.id_trainer,
    tr.name AS nombre_entrenador,
    SUM(t.amount) AS total_transacciones
FROM transactions t
JOIN trainers tr ON t.id_trainer = t.id_trainer
GROUP BY t.id_trainer, tr.name
ORDER BY total_transacciones DESC
LIMIT 10;
-- 6. Additional query: Recent badges by battle
EXPLAIN
SELECT 
    bg.id_badge,
    b.battle_name,
    bg.badge_name,
    bg.earned_date
FROM badges bg
JOIN battles b ON bg.id_battle = b.id_battle
WHERE bg.status = 'Earned' AND b.battle_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
LIMIT 10;