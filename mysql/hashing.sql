UPDATE trainers
SET name = 'Entrenador';
UPDATE trainers
SET email = CONCAT('ofuscado_', id_trainer, '@pokemon.com');
UPDATE transactions
SET transaction_type = 'tipo_transaccion_ofuscado';
SELECT id_transaction, id_trainer, transaction_type, amount, status,
       JSON_OBJECT('clave', 'valor') AS details_simulado
FROM transactions
LIMIT 10;

SELECT * FROM transactions;
SELECT * FROM badges;