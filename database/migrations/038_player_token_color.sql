ALTER TABLE scenario_players
  ADD COLUMN IF NOT EXISTS token_color VARCHAR(20) NULL AFTER health;
