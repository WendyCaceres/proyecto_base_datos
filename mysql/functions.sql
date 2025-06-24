-- 6 funciones reutilizables y 6 stored
DELIMITER //

-- 1. Function to authenticate trainer
CREATE FUNCTION autenticar_entrenador(
    p_email TEXT,
    p_contrasena TEXT
)
RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_password_hash TEXT;
    DECLARE v_count INT DEFAULT 0;
    
    SELECT password INTO v_password_hash
    FROM trainers
    WHERE email = p_email;
    
    SELECT COUNT(*) INTO v_count
    FROM trainers 
    WHERE email = p_email;
    
    IF v_count = 0 THEN
        RETURN FALSE;
    END IF;

    IF SHA2(p_contrasena, 256) = v_password_hash THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END//

-- 2. Function to get trainer's PokéCoins balance
CREATE FUNCTION get_saldo_entrenador(p_id_trainer INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE v_poke_coins DECIMAL(12,2);
    
    SELECT poke_coins INTO v_poke_coins
    FROM trainers
    WHERE id_trainer = p_id_trainer;

    RETURN IFNULL(v_poke_coins, 0);
END//

-- 3. Procedure to get active battles
CREATE PROCEDURE get_batallas_activas()
READS SQL DATA
BEGIN
    SELECT id_battle, battle_name, battle_type, battle_date
    FROM battles
    WHERE battle_date > NOW() AND status != 'Canceled';
END//

-- 4. Procedure to get moves by battle
CREATE PROCEDURE get_movimientos_por_batalla(IN p_id_battle INT)
READS SQL DATA
BEGIN
    SELECT id_move, move_name, power, status
    FROM moves
    WHERE id_battle = p_id_battle AND status = 1;
END//

-- 5. Procedure to get badges by trainer
CREATE PROCEDURE get_insignias_por_entrenador(IN p_id_trainer INT)
READS SQL DATA
BEGIN
    SELECT bg.id_badge, b.battle_name, bg.badge_name, bg.status
    FROM badges bg
    JOIN battles b ON bg.id_battle = b.id_battle
    WHERE bg.id_trainer = p_id_trainer;
END//

-- 6. Procedure to get battle comments
CREATE PROCEDURE get_comentarios_batalla(IN p_id_battle INT)
READS SQL DATA
BEGIN
    SELECT t.name AS trainer_name, bc.comment, bc.created_at AS fecha
    FROM battle_comments bc
    JOIN trainers t ON bc.id_trainer = t.id_trainer
    WHERE bc.id_battle = p_id_battle;
END//

-- 7. Procedure to update trainer's PokéCoins balance
CREATE PROCEDURE actualizar_saldo_entrenador(
    IN p_id_trainer INT, 
    IN p_nuevo_saldo DECIMAL(12,2)
)
MODIFIES SQL DATA
BEGIN
    UPDATE trainers 
    SET poke_coins = p_nuevo_saldo, updated_at = CURRENT_TIMESTAMP
    WHERE id_trainer = p_id_trainer;
END//

-- 8. Procedure to update battle result
CREATE PROCEDURE actualizar_resultado_batalla(
    IN p_id_battle INT, 
    IN p_resultado JSON
)
MODIFIES SQL DATA
BEGIN
    UPDATE battles 
    SET result = p_resultado, updated_at = CURRENT_TIMESTAMP
    WHERE id_battle = p_id_battle;
END//

DELIMITER ;