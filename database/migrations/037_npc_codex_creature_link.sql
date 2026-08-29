ALTER TABLE npc_characters
  ADD COLUMN IF NOT EXISTS codex_creature_id BIGINT UNSIGNED NULL AFTER image_asset_id,
  ADD INDEX IF NOT EXISTS idx_npc_codex_creature (codex_creature_id),
  ADD CONSTRAINT fk_npc_codex_creature FOREIGN KEY IF NOT EXISTS (codex_creature_id) REFERENCES creatures(id) ON DELETE SET NULL;
