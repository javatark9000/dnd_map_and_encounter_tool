ALTER TABLE scenarios
  ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN NOT NULL DEFAULT FALSE AFTER active,
  ADD INDEX IF NOT EXISTS idx_scenarios_visible (campaign_id, is_deleted, active, name);
