-- Crear roles
CREATE ROLE admin;
CREATE ROLE trainer;
CREATE ROLE gym_leader;

-- Permisos para admin (acceso total a la base de datos pokemon_db)
GRANT ALL PRIVILEGES ON pokemon_db.* TO admin;

-- Permisos para trainer
GRANT SELECT ON pokemon_db.battles TO trainer;
GRANT SELECT ON pokemon_db.pokemon TO trainer;
GRANT SELECT ON pokemon_db.tournaments TO trainer;
GRANT SELECT ON pokemon_db.badges TO trainer;
GRANT SELECT, INSERT ON pokemon_db.battle_comments TO trainer;
GRANT SELECT, INSERT ON pokemon_db.transactions TO trainer;
GRANT SELECT, INSERT ON pokemon_db.items TO trainer;

-- Permisos para gym_leader
GRANT SELECT, UPDATE ON pokemon_db.trainers TO gym_leader;
GRANT SELECT, INSERT, UPDATE ON pokemon_db.battles TO gym_leader;
GRANT SELECT, INSERT, UPDATE ON pokemon_db.badges TO gym_leader;
GRANT SELECT, INSERT, UPDATE ON pokemon_db.transactions TO gym_leader;

-- Crear usuarios y asignar roles
CREATE USER 'ash'@'%' IDENTIFIED BY 'pikachu123';
GRANT trainer TO 'ash'@'%';
SET DEFAULT ROLE trainer TO 'ash'@'%';

CREATE USER 'brock'@'%' IDENTIFIED BY 'onix123';
GRANT gym_leader TO 'brock'@'%';
SET DEFAULT ROLE gym_leader TO 'brock'@'%';

CREATE USER 'admin1'@'%' IDENTIFIED BY 'admin123';
GRANT admin TO 'admin1'@'%';
SET DEFAULT ROLE admin TO 'admin1'@'%';