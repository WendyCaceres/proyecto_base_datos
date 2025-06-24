-- 6 triggers
-- 1. Trigger to log badge creation
DELIMITER //
CREATE TRIGGER tr_log_creacion_insignia
AFTER INSERT ON badges
FOR EACH ROW
BEGIN
    INSERT INTO logs_json (log_type, data)
    VALUES (
        'CREAR_INSIGNIA',
        JSON_OBJECT(
            'id_badge', NEW.id_badge,
            'id_trainer', NEW.id_trainer,
            'id_battle', NEW.id_battle,
            'badge_name', NEW.badge_name,
            'created_at', NEW.created_at
        )
    );
END//
DELIMITER ;

-- 2. Trigger to log PokeCoins balance changes
DELIMITER //
CREATE TRIGGER tr_log_cambio_poke_coins
AFTER UPDATE ON trainers
FOR EACH ROW
BEGIN
    IF NEW.poke_coins != OLD.poke_coins THEN
        INSERT INTO logs_json (log_type, data)
        VALUES (
            'CAMBIO_POKE_COINS',
            JSON_OBJECT(
                'id_trainer', NEW.id_trainer,
                'poke_coins_anterior', OLD.poke_coins,
                'poke_coins_nuevo', NEW.poke_coins,
                'fecha_modificacion', NOW()
            )
        );
    END IF;
END//
DELIMITER ;

-- 3. Trigger to log failed badges
DELIMITER //
CREATE TRIGGER tr_log_insignia_fallida
AFTER UPDATE ON badges
FOR EACH ROW
BEGIN
    IF NEW.status = 'Failed' AND OLD.status != 'Failed' THEN
        INSERT INTO logs_json (log_type, data)
        VALUES (
            'INSIGNIA_FALLIDA',
            JSON_OBJECT(
                'id_badge', NEW.id_badge,
                'id_trainer', NEW.id_trainer,
                'badge_name', NEW.badge_name,
                'fecha_fallo', NOW()
            )
        );
    END IF;
END//
DELIMITER ;

-- 4. Trigger to validate non-negative PokeCoins balance
DELIMITER //
CREATE TRIGGER tr_validar_poke_coins_no_negativo
BEFORE UPDATE ON trainers
FOR EACH ROW
BEGIN
    IF NEW.poke_coins < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se permite saldo de PokeCoins negativo';
    END IF;
END//
DELIMITER ;

-- 5. Trigger to log battle result updates
DELIMITER //
CREATE TRIGGER tr_log_resultado_batalla
AFTER UPDATE ON battles
FOR EACH ROW
BEGIN
    IF JSON_EXTRACT(NEW.result, '$') != JSON_EXTRACT(OLD.result, '$') OR 
       (NEW.result IS NOT NULL AND OLD.result IS NULL) OR
       (NEW.result IS NULL AND OLD.result IS NOT NULL) THEN
        INSERT INTO logs_json (log_type, data)
        VALUES (
            'RESULTADO_BATALLA_ACTUALIZADO',
            JSON_OBJECT(
                'id_battle', NEW.id_battle,
                'resultado_anterior', OLD.result,
                'resultado_nuevo', NEW.result,
                'fecha', NOW()
            )
        );
    END IF;
END//
DELIMITER ;

-- 6. Trigger to assign default badge status based on battle
DELIMITER //
CREATE TRIGGER tr_asignar_estado_insignia
BEFORE INSERT ON badges
FOR EACH ROW
BEGIN
    DECLARE batalla_estado VARCHAR(20);
    
    SELECT status INTO batalla_estado
    FROM battles
    WHERE id_battle = NEW.id_battle;

    SET NEW.status = IF(batalla_estado = 'Completed', 'Earned', 'Pending');
END//
DELIMITER ;