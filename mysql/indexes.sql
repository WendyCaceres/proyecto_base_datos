-- Indices for badges 
CREATE INDEX idx_badges_status ON badges (status);
CREATE INDEX idx_badges_trainer ON badges (id_trainer);
CREATE INDEX idx_badges_battle ON badges (id_battle);

-- Indices for moves 
CREATE INDEX idx_moves_battle ON moves (id_battle);

-- Indices for battles 
CREATE INDEX idx_battles_id ON battles (id_battle);

-- Indices for trainers 
CREATE INDEX idx_trainers_id ON trainers (id_trainer);

-- Composite index for badges by trainer and status
CREATE INDEX idx_badges_trainer_status ON badges (id_trainer, status);

-- Additional index for transactions 
CREATE INDEX idx_transactions_trainer ON transactions (id_trainer);
CREATE INDEX idx_transactions_status ON transactions (status);
CREATE INDEX idx_transactions_trainer_amount ON transactions (id_trainer, amount);