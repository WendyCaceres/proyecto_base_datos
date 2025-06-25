CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. Function to authenticate trainer
CREATE OR REPLACE FUNCTION autenticar_entrenador(
    p_email TEXT,
    p_contrasena TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_password_hash TEXT;
BEGIN
    SELECT password INTO v_password_hash
    FROM trainers
    WHERE email = p_email;

    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;

    IF crypt(p_contrasena, v_password_hash) = v_password_hash THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;

-- 2. Function to get trainer's PokeCoins balance
CREATE OR REPLACE FUNCTION get_saldo_entrenador(p_id_trainer INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_poke_coins NUMERIC;
BEGIN
    SELECT poke_coins INTO v_poke_coins
    FROM trainers
    WHERE id_trainer = p_id_trainer;

    RETURN COALESCE(v_poke_coins, 0);
END;
$$;

-- 3. Function to get active battles
CREATE OR REPLACE FUNCTION get_batallas_activas()
RETURNS TABLE(
    id_battle INT,
    battle_name TEXT,
    battle_type TEXT,
    battle_date TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT id_battle, battle_name, battle_type, battle_date
    FROM battles
    WHERE battle_date > NOW() AND status != 'Canceled';
END;
$$;

-- 4. Function to get moves by battle
CREATE OR REPLACE FUNCTION get_movimientos_por_batalla(p_id_battle INT)
RETURNS TABLE(
    id_move INT,
    move_name TEXT,
    power INT,
    status BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT id_move, move_name, power, status
    FROM moves
    WHERE id_battle = p_id_battle AND status = TRUE;
END;
$$;

-- 5. Function to get badges by trainer
CREATE OR REPLACE FUNCTION get_insignias_por_entrenador(p_id_trainer INT)
RETURNS TABLE(
    id_badge INT,
    battle_name TEXT,
    badge_name TEXT,
    earned_date TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT bg.id_badge, b.battle_name, bg.badge_name, bg.earned_date
    FROM badges bg
    JOIN battles b ON bg.id_battle = b.id_battle
    WHERE bg.id_trainer = p_id_trainer;
END;
$$;

-- 6. Function to get battle comments
CREATE OR REPLACE FUNCTION get_comentarios_batalla(p_id_battle INT)
RETURNS TABLE(
    id_trainer INT,
    comment TEXT,
    created_at TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT id_trainer, comment, created_at
    FROM battle_comments
    WHERE id_battle = p_id_battle;
END;
$$;

-- Test 
SELECT autenticar_entrenador('trainer1@example.com', 'password123');
SELECT get_saldo_entrenador(1);
SELECT * FROM get_batallas_activas() LIMIT 10;
SELECT * FROM get_movimientos_por_batalla(1) LIMIT 10;
SELECT * FROM get_insignias_por_entrenador(1) LIMIT 10;
SELECT * FROM get_comentarios_batalla(1) LIMIT 10;