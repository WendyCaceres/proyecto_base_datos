UPDATE trainers
SET name = 'Entrenador_' || id_trainer;
UPDATE trainers
SET email = 'ofuscado_' || id_trainer || '@pokemon.com';
UPDATE items
SET item_type = 'item_ofuscado_' || id_item;
SELECT id_trainer, name, email FROM trainers LIMIT 5;
SELECT id_item, item_type FROM items LIMIT 5;