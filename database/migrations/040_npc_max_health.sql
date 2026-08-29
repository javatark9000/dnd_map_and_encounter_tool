ALTER TABLE npc_characters
  ADD COLUMN IF NOT EXISTS max_health INT NULL AFTER health;

UPDATE npc_characters SET max_health = health WHERE max_health IS NULL;
