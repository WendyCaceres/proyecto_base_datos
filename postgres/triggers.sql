-- 1. Trigger to log badge creation
CREATE OR REPLACE FUNCTION log_creacion_insignia()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO logs_json (log_type, data)
    VALUES (
        'CREAR_INSIGNIA',
        jsonb_build_object(
            'id_badge', NEW.id_badge,
            'id_trainer', NEW.id_trainer,
            'id_battle', NEW.id_battle,
            'badge_name', NEW.badge_name,
            'created_at', NEW.created_at
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_log_creacion_insignia
AFTER INSERT ON badges
FOR EACH ROW
EXECUTE FUNCTION log_creacion_insignia();

-- 2. Trigger to log PokeCoins balance changes
CREATE OR REPLACE FUNCTION log_cambio_poke_coins()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.poke_coins IS DISTINCT FROM OLD.poke_coins THEN
        INSERT INTO logs_json (log_type, data)
        VALUES (
            'CAMBIO_POKE_COINS',
            jsonb_build_object(
                'id_trainer', NEW.id_trainer,
                'poke_coins_anterior', OLD.poke_coins,
                'poke_coins_nuevo', NEW.poke_coins,
                'fecha_modificacion', NOW()
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_log_cambio_poke_coins
AFTER UPDATE ON trainers
FOR EACH ROW
WHEN (OLD.poke_coins IS DISTINCT FROM NEW.poke_coins)
EXECUTE FUNCTION log_cambio_poke_coins();

-- 3. Trigger to log failed badges
CREATE OR REPLACE FUNCTION log_insignia_fallida()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'Failed' AND OLD.status IS DISTINCT FROM 'Failed' THEN
        INSERT INTO logs_json (log_type, data)
        VALUES (
            'INSIGNIA_FALLIDA',
            jsonb_build_object(
                'id_badge', NEW.id_badge,
                'id_trainer', NEW.id_trainer,
                'badge_name', NEW.badge_name,
                'fecha_fallo', NOW()
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_log_insignia_fallida
AFTER UPDATE ON badges
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status)
EXECUTE FUNCTION log_insignia_fallida();

-- 4. Trigger to validate non-negative PokeCoins balance
CREATE OR REPLACE FUNCTION validar_poke_coins_no_negativo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.poke_coins < 0 THEN
        RAISE EXCEPTION 'No se permite saldo de PokeCoins negativo para el entrenador %', NEW.id_trainer;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_validar_poke_coins_no_negativo
BEFORE UPDATE ON trainers
FOR EACH ROW
EXECUTE FUNCTION validar_poke_coins_no_negativo();

-- 5. Trigger to log battle result updates
CREATE OR REPLACE FUNCTION log_resultado_batalla()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.result IS DISTINCT FROM OLD.result THEN
        INSERT INTO logs_json (log_type, data)
        VALUES (
            'RESULTADO_BATALLA_ACTUALIZADO',
            jsonb_build_object(
                'id_battle', NEW.id_battle,
                'resultado_anterior', OLD.result,
                'resultado_nuevo', NEW.result,
                'fecha', NOW()
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_log_resultado_batalla
AFTER UPDATE ON battles
FOR EACH ROW
WHEN (OLD.result IS DISTINCT FROM NEW.result)
EXECUTE FUNCTION log_resultado_batalla();

-- 6. Trigger to assign default badge status based on battle
CREATE OR REPLACE FUNCTION asignar_estado_insignia()
RETURNS TRIGGER AS $$
DECLARE
    batalla_estado VARCHAR(20);
BEGIN
    SELECT status INTO batalla_estado
    FROM battles
    WHERE id_battle = NEW.id_battle;

    NEW.status := CASE WHEN batalla_estado = 'Completed' THEN 'Earned' ELSE 'Pending' END;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_asignar_estado_insignia
BEFORE INSERT ON badges
FOR EACH ROW
EXECUTE FUNCTION asignar_estado_insignia();