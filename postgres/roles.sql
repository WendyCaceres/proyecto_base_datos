-- Crear roles
CREATE ROLE admin;
CREATE ROLE trainer;
CREATE ROLE gym_leader;

-- Permisos para admin (acceso total al esquema public)
GRANT ALL PRIVILEGES ON SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO admin;

-- Permisos para trainer
GRANT USAGE ON SCHEMA public TO trainer;
GRANT SELECT ON battles TO trainer;
GRANT SELECT ON pokemon TO trainer;
GRANT SELECT ON tournaments TO trainer;
GRANT SELECT ON badges TO trainer;
GRANT SELECT, INSERT ON battle_comments TO trainer;
GRANT SELECT, INSERT ON transactions TO trainer;
GRANT SELECT, INSERT ON items TO trainer;

-- Permisos para gym_leader
GRANT USAGE ON SCHEMA public TO gym_leader;
GRANT SELECT, UPDATE ON trainers TO gym_leader;
GRANT SELECT, INSERT, UPDATE ON battles TO gym_leader;
GRANT SELECT, INSERT, UPDATE ON badges TO gym_leader;
GRANT SELECT, INSERT, UPDATE ON transactions TO gym_leader;

-- Crear usuarios y asignar roles
CREATE USER ash WITH PASSWORD 'pikachu123';
GRANT trainer TO ash;

CREATE USER brock WITH PASSWORD 'onix123';
GRANT gym_leader TO brock;

CREATE USER admin1 WITH PASSWORD 'admin123';
GRANT admin TO admin1;