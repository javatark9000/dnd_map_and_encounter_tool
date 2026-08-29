ALTER TABLE actions
  ADD COLUMN IF NOT EXISTS custom_identifier VARCHAR(120) NULL AFTER created_by_user_id,
  ADD COLUMN IF NOT EXISTS custom_tag VARCHAR(80) NULL AFTER custom_identifier,
  ADD INDEX IF NOT EXISTS idx_actions_custom_identifier (custom_identifier),
  ADD INDEX IF NOT EXISTS idx_actions_custom_tag (custom_tag);
