DROP TABLE IF EXISTS trainers CASCADE;
CREATE TABLE trainers (
    id_trainer SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password TEXT,
    poke_coins NUMERIC(12, 2),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS roles CASCADE;
CREATE TABLE roles (
    id_role SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE, 
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS trainer_role CASCADE;
CREATE TABLE trainer_role (
    id_trainer INT REFERENCES trainers(id_trainer),
    id_role INT REFERENCES roles(id_role),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id_trainer, id_role)
);

DROP TABLE IF EXISTS battles CASCADE;
CREATE TABLE battles (
    id_battle SERIAL PRIMARY KEY,
    battle_name VARCHAR(100), 
    battle_type VARCHAR(50), 
    battle_date TIMESTAMP,
    result JSONB, 
    status VARCHAR(20), 
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS moves CASCADE;
CREATE TABLE moves (
    id_move SERIAL PRIMARY KEY,
    id_battle INT REFERENCES battles(id_battle),
    move_name VARCHAR(50), 
    power INT, 
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS items CASCADE;
CREATE TABLE items (
    id_item SERIAL PRIMARY KEY,
    id_trainer INT REFERENCES trainers(id_trainer),
    item_type VARCHAR(50), 
    details JSONB, 
    active BOOLEAN DEFAULT TRUE,
    acquired_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS battle_comments CASCADE;
CREATE TABLE battle_comments (
    id_trainer INT REFERENCES trainers(id_trainer),
    id_battle INT REFERENCES battles(id_battle),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id_trainer, id_battle)
);

DROP TABLE IF EXISTS tournaments CASCADE;
CREATE TABLE tournaments (
    id_tournament SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE, 
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS battle_tournaments CASCADE;
CREATE TABLE battle_tournaments (
    id_tournament INT REFERENCES tournaments(id_tournament) ON DELETE CASCADE,
    id_battle INT REFERENCES battles(id_battle) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id_tournament, id_battle)
);

DROP TABLE IF EXISTS badges CASCADE;
CREATE TABLE badges (
    id_badge SERIAL PRIMARY KEY,
    id_trainer INT REFERENCES trainers(id_trainer),
    id_battle INT REFERENCES battles(id_battle),
    badge_name VARCHAR(50), 
    earned_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20), 
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE transactions (
    id_transaction SERIAL PRIMARY KEY,
    id_trainer INT REFERENCES trainers(id_trainer),
    transaction_type VARCHAR(20), 
    amount NUMERIC(10, 2),
    status VARCHAR(20), 
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS pokemon CASCADE;
CREATE TABLE pokemon (
    id_pokemon SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL, 
    type VARCHAR(50), 
    level INT,
    sprite_url VARCHAR(255),
    capture_date DATE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS battle_pokemon CASCADE;
CREATE TABLE battle_pokemon (
    id_battle INT REFERENCES battles(id_battle),
    id_pokemon INT REFERENCES pokemon(id_pokemon),
    is_trainer1 BOOLEAN DEFAULT FALSE, 
    hp_remaining INT DEFAULT 100,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id_battle, id_pokemon)
);

DROP TABLE IF EXISTS sponsors CASCADE;
CREATE TABLE sponsors (
    id_sponsor SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL, 
    logo_url VARCHAR(255),
    website VARCHAR(255),
    contact_email VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS battle_sponsors CASCADE;
CREATE TABLE battle_sponsors (
    id_battle INT REFERENCES battles(id_battle),
    id_sponsor INT REFERENCES sponsors(id_sponsor),
    sponsorship_type VARCHAR(50), 
    amount NUMERIC(12, 2),
    logo_position VARCHAR(30), 
    start_date DATE,
    end_date DATE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id_battle, id_sponsor)
);

DROP TABLE IF EXISTS battle_history CASCADE;
CREATE TABLE battle_history (
    id SERIAL PRIMARY KEY,
    id_trainer INT REFERENCES trainers(id_trainer),
    history JSONB, 
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS logs_json CASCADE;
CREATE TABLE logs_json (
    id BIGSERIAL,
    log_type VARCHAR(50), 
    data JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
) PARTITION BY RANGE (created_at);

CREATE TABLE 
    logs_json_2025_01 PARTITION OF logs_json FOR 
VALUES 
FROM   
    ('2025-01-01') TO ('2025-02-01');

CREATE TABLE 
    logs_json_2025_02 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-02-01') TO ('2025-03-01');

CREATE TABLE 
    logs_json_2025_03 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-03-01') TO ('2025-04-01');

CREATE TABLE 
    logs_json_2025_04 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-04-01') TO ('2025-05-01');

CREATE TABLE 
    logs_json_2025_05 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-05-01') TO ('2025-06-01');

CREATE TABLE 
    logs_json_2025_06 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-06-01') TO ('2025-07-01');

CREATE TABLE 
    logs_json_2025_07 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-07-01') TO ('2025-08-01');

CREATE TABLE 
    logs_json_2025_08 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-08-01') TO ('2025-09-01');

CREATE TABLE 
    logs_json_2025_09 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-09-01') TO ('2025-10-01');

CREATE TABLE 
    logs_json_2025_10 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-10-01') TO ('2025-11-01');

CREATE TABLE 
    logs_json_2025_11 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-11-01') TO ('2025-12-01');
CREATE TABLE 
    logs_json_2025_12 PARTITION OF logs_json FOR 
VALUES 
FROM 
    ('2025-12-01') TO ('2026-01-01');