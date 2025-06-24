--3 Vistas
-- 1. View: vista_insignias_activas
CREATE OR REPLACE VIEW vista_insignias_activas AS
SELECT 
    bg.id_badge,
    t.name AS nombre_entrenador,
    b.battle_name AS nombre_batalla,
    bg.badge_name,
    bg.earned_date
FROM badges bg
JOIN trainers t ON t.id_trainer = bg.id_trainer
JOIN battles b ON b.id_battle = bg.id_battle
WHERE bg.status = 'Earned';

SELECT * FROM vista_insignias_activas LIMIT 10;

-- 2. View: vista_top_entrenadores_insignias
CREATE OR REPLACE VIEW vista_top_entrenadores_insignias AS
SELECT 
    t.id_trainer,
    t.name AS nombre_entrenador,
    COUNT(bg.id_badge) AS total_insignias,
    COALESCE(t.poke_coins, 0) AS poke_coins_total
FROM trainers t
LEFT JOIN badges bg ON t.id_trainer = bg.id_trainer
GROUP BY t.id_trainer, t.name
ORDER BY total_insignias DESC;

SELECT * FROM vista_top_entrenadores_insignias LIMIT 10;

-- 3. View: vista_batallas_finalizadas
CREATE OR REPLACE VIEW vista_batallas_finalizadas AS
SELECT 
    id_battle,
    battle_name,
    battle_type,
    battle_date,
    result
FROM battles
WHERE result IS NOT NULL AND status = 'Completed';

SELECT * FROM vista_batallas_finalizadas LIMIT 10;