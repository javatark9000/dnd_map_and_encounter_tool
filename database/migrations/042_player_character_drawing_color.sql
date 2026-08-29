ALTER TABLE player_characters
  ADD COLUMN IF NOT EXISTS drawing_color VARCHAR(20) NOT NULL DEFAULT '#ffffff' AFTER avatar_asset_id;

UPDATE player_characters SET drawing_color='#ffffff' WHERE drawing_color IS NULL OR drawing_color='';
