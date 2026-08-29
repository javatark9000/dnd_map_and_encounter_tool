ALTER TABLE npc_characters
  ADD COLUMN IF NOT EXISTS armor_class INT NULL AFTER health;
