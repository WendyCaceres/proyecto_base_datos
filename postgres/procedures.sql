CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. Procedure to insert a trainer
CREATE OR REPLACE PROCEDURE sp_insertar_entrenador(
    p_name TEXT,
    p_email TEXT,
    p_contrasena TEXT,
    p_poke_coins NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        INSERT INTO trainers (name, email, password, poke_coins, active)
        VALUES (p_name, p_email, crypt(p_contrasena, gen_salt('bf')), p_poke_coins, TRUE);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al insertar entrenador: %', SQLERRM;
            ROLLBACK;
            RAISE EXCEPTION 'Fallo al insertar entrenador';
    END;
END;
$$;

-- 2. Procedure to delete a badge
CREATE OR REPLACE PROCEDURE sp_eliminar_insignia(p_id_badge INT)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        DELETE FROM badges
        WHERE id_badge = p_id_badge AND status = 'Earned';

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró insignia activa con ID %', p_id_badge;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al eliminar insignia: %', SQLERRM;
            ROLLBACK;
            RAISE EXCEPTION 'Fallo al eliminar insignia';
    END;
END;
$$;

-- 3. Procedure to register a battle
CREATE OR REPLACE PROCEDURE sp_registrar_batalla(
    p_battle_name VARCHAR(100),
    p_battle_date TIMESTAMP,
    p_battle_type VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        INSERT INTO battles (battle_name, battle_date, battle_type, status)
        VALUES (p_battle_name, p_battle_date, p_battle_type, 'Scheduled');
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al registrar batalla: %', SQLERRM;
            ROLLBACK;
            RAISE EXCEPTION 'Fallo al registrar batalla';
    END;
END;
$$;

-- 4. Procedure to cancel a battle
CREATE OR REPLACE PROCEDURE sp_cancelar_batalla(p_id_battle INT)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        -- Update battle status
        UPDATE battles
        SET result = jsonb_build_object('estado', 'CANCELADO'),
            status = 'Canceled',
            updated_at = NOW()
        WHERE id_battle = p_id_battle;

        -- Update associated badges
        UPDATE badges
        SET status = 'Failed',
            updated_at = NOW()
        WHERE id_battle = p_id_battle;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró batalla con ID %', p_id_battle;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al cancelar batalla: %', SQLERRM;
            ROLLBACK;
            RAISE EXCEPTION 'Fallo al cancelar batalla';
    END;
END;
$$;

-- 5. Procedure to withdraw PokeCoins
CREATE OR REPLACE PROCEDURE sp_retirar_poke_coins(p_id_trainer INT, p_amount NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        IF p_amount <= 0 THEN
            RAISE EXCEPTION 'El monto debe ser positivo.';
        END IF;

        UPDATE trainers
        SET poke_coins = poke_coins - p_amount,
            updated_at = NOW()
        WHERE id_trainer = p_id_trainer AND poke_coins >= p_amount;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Fondos insuficientes o entrenador no encontrado.';
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al retirar PokeCoins: %', SQLERRM;
            ROLLBACK;
            RAISE EXCEPTION 'Fallo al retirar PokeCoins';
    END;
END;
$$;

-- 6. Procedure to register a transaction
CREATE OR REPLACE PROCEDURE sp_registrar_transaccion(
    IN p_id_trainer INT,
    IN p_transaction_type VARCHAR(20),
    IN p_amount NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_poke_coins_actual NUMERIC;
    v_battle_active BOOLEAN;
BEGIN
    BEGIN
        SELECT poke_coins INTO v_poke_coins_actual
        FROM trainers
        WHERE id_trainer = p_id_trainer;

        IF p_transaction_type = 'Withdraw' AND v_poke_coins_actual < p_amount THEN
            RAISE EXCEPTION 'PokeCoins insuficientes.';
        END IF;

        INSERT INTO transactions (id_trainer, transaction_type, amount, status)
        VALUES (p_id_trainer, p_transaction_type, p_amount, 'Completed');

        IF p_transaction_type = 'Deposit' THEN
            UPDATE trainers
            SET poke_coins = poke_coins + p_amount,
                updated_at = NOW()
            WHERE id_trainer = p_id_trainer;
        ELSIF p_transaction_type = 'Withdraw' THEN
            UPDATE trainers
            SET poke_coins = poke_coins - p_amount,
                updated_at = NOW()
            WHERE id_trainer = p_id_trainer;
        END IF;

        COMMIT;
        RAISE NOTICE 'Transacción registrada con éxito.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al registrar transacción: %', SQLERRM;
            ROLLBACK;
            RAISE EXCEPTION 'Fallo al registrar transacción';
    END;
END;
$$;

-- Test
CALL sp_insertar_entrenador('Ash Ketchum', 'ash@example.com', 'pikachu123', 1000.00);
CALL sp_eliminar_insignia(1);
CALL sp_registrar_batalla('Elite Four Battle', '2025-12-01 15:00:00', 'Tournament');
CALL sp_cancelar_batalla(1);
CALL sp_retirar_poke_coins(1, 50.00);
CALL sp_registrar_transaccion(1, 'Deposit', 100.00);