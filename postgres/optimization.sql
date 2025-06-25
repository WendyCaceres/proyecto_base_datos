-- 1. Optimization analysis for vista_insignias_activas
EXPLAIN ANALYZE
SELECT * FROM vista_insignias_activas LIMIT 10;

-- 2. Optimization analysis for vista_top_entrenadores_insignias
EXPLAIN ANALYZE
SELECT * FROM vista_top_entrenadores_insignias LIMIT 10;

-- 3. Optimization analysis for vista_batallas_finalizadas
EXPLAIN ANALYZE
SELECT * FROM vista_batallas_finalizadas LIMIT 10;

-- 4. Optimization analysis for get_insignias_por_entrenador
EXPLAIN ANALYZE
SELECT id_badge, battle_name, badge_name, earned_date
FROM badges bg
JOIN battles b ON bg.id_battle = b.id_battle
WHERE bg.id_trainer = 1;

-- 5. Additional query: Transactions by trainer
EXPLAIN ANALYZE
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

-- 6. Additional query: Cancel battle (sp_cancelar_batalla)
EXPLAIN ANALYZE
UPDATE badges
SET status = 'Failed'
WHERE id_battle = 400;
