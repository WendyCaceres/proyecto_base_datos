SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    id_transaction INT AUTO_INCREMENT PRIMARY KEY,
    id_trainer INT, -- viene de PostgreSQL
    transaction_type VARCHAR(20), 
    amount DECIMAL(10, 2),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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

DROP TABLE IF EXISTS battle_history;
CREATE TABLE battle_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_trainer INT, -- viene de PostgreSQL
    history JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS items;
CREATE TABLE items (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_trainer INT, -- viene de PostgreSQL
    item_type VARCHAR(50), 
    details JSON, 
    active TINYINT(1) DEFAULT 1,
    acquired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS battle_comments;
CREATE TABLE battle_comments (
    id_trainer INT, -- viene de PostgreSQL
    id_battle INT,  -- viene de PostgreSQL
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id_trainer, id_battle)
);

DROP TABLE IF EXISTS moves;
CREATE TABLE moves (
    id_move INT AUTO_INCREMENT PRIMARY KEY,
    id_battle INT, -- viene de PostgreSQL
    move_name VARCHAR(50), 
    power INT, 
    status TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SET FOREIGN_KEY_CHECKS = 1;
