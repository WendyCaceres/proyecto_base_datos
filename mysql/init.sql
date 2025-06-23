SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS trainers;
CREATE TABLE trainers (
    id_trainer INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password TEXT,
    poke_coins DECIMAL(12, 2),
    active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS roles;
CREATE TABLE roles (
    id_role INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS trainer_role;
CREATE TABLE trainer_role (
    id_trainer INT,
    id_role INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_trainer, id_role),
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer),
    FOREIGN KEY (id_role) REFERENCES roles(id_role)
);

DROP TABLE IF EXISTS battles;
CREATE TABLE battles (
    id_battle INT AUTO_INCREMENT PRIMARY KEY,
    battle_name VARCHAR(100), 
    battle_type VARCHAR(50), 
    battle_date TIMESTAMP,
    result JSON,
    status VARCHAR(20), 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS moves;
CREATE TABLE moves (
    id_move INT AUTO_INCREMENT PRIMARY KEY,
    id_battle INT,
    move_name VARCHAR(50), 
    power INT, 
    status TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_battle) REFERENCES battles(id_battle)
);

DROP TABLE IF EXISTS items;
CREATE TABLE items (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_trainer INT,
    item_type VARCHAR(50), 
    details JSON, 
    active TINYINT(1) DEFAULT 1,
    acquired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer)
);

DROP TABLE IF EXISTS battle_comments;
CREATE TABLE battle_comments (
    id_trainer INT,
    id_battle INT,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_trainer, id_battle),
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer),
    FOREIGN KEY (id_battle) REFERENCES battles(id_battle)
);

DROP TABLE IF EXISTS tournaments;
CREATE TABLE tournaments (
    id_tournament INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS battle_tournaments;
CREATE TABLE battle_tournaments (
    id_tournament INT,
    id_battle INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_tournament, id_battle),
    FOREIGN KEY (id_tournament) REFERENCES tournaments(id_tournament) ON DELETE CASCADE,
    FOREIGN KEY (id_battle) REFERENCES battles(id_battle) ON DELETE CASCADE
);

DROP TABLE IF EXISTS badges;
CREATE TABLE badges (
    id_badge INT AUTO_INCREMENT PRIMARY KEY,
    id_trainer INT,
    id_battle INT,
    badge_name VARCHAR(50), 
    earned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer),
    FOREIGN KEY (id_battle) REFERENCES battles(id_battle)
);

DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    id_transaction INT AUTO_INCREMENT PRIMARY KEY,
    id_trainer INT,
    transaction_type VARCHAR(20), 
    amount DECIMAL(10, 2),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer)
);

DROP TABLE IF EXISTS pokemon;
CREATE TABLE pokemon (
    id_pokemon INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, 
    type VARCHAR(50), 
    level INT,
    sprite_url VARCHAR(255),
    capture_date DATE,
    active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS battle_pokemon;
CREATE TABLE battle_pokemon (
    id_battle INT,
    id_pokemon INT,
    is_trainer1 TINYINT(1) DEFAULT 0, 
    hp_remaining INT DEFAULT 100,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_battle, id_pokemon),
    FOREIGN KEY (id_battle) REFERENCES battles(id_battle),
    FOREIGN KEY (id_pokemon) REFERENCES pokemon(id_pokemon)
);

DROP TABLE IF EXISTS sponsors;
CREATE TABLE sponsors (
    id_sponsor INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    logo_url VARCHAR(255),
    website VARCHAR(255),
    contact_email VARCHAR(100),
    active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS battle_sponsors;
CREATE TABLE battle_sponsors (
    id_battle INT,
    id_sponsor INT,
    sponsorship_type VARCHAR(50), 
    amount DECIMAL(12, 2),
    logo_position VARCHAR(30), 
    start_date DATE,
    end_date DATE,
    active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_battle, id_sponsor),
    FOREIGN KEY (id_battle) REFERENCES battles(id_battle),
    FOREIGN KEY (id_sponsor) REFERENCES sponsors(id_sponsor)
);

DROP TABLE IF EXISTS battle_history;
CREATE TABLE battle_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_trainer INT,
    history JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_trainer) REFERENCES trainers(id_trainer)
);

DROP TABLE IF EXISTS logs_json;
CREATE TABLE logs_json (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    log_type VARCHAR(50), 
    data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_log_type (log_type),
    INDEX idx_created_at (created_at)
);

SET FOREIGN_KEY_CHECKS = 1;