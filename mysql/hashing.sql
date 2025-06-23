-- Update trainer names to a generic value
UPDATE trainers
SET name = 'Entrenador';

-- Update trainer emails to an obfuscated format
UPDATE trainers
SET email = CONCAT('ofuscado_', id_trainer, '@pokemon.com');

-- Update transaction types to an obfuscated value
UPDATE transactions
SET transaction_type = 'tipo_transaccion_ofuscado';

-- Update transactions with a simulated JSON field (for demonstration)
SELECT id_transaction, id_trainer, transaction_type, amount, status,
       JSON_OBJECT('clave', 'valor') AS details_simulado
FROM transactions
LIMIT 10;

SELECT * FROM transactions;
SELECT * FROM badges;