USE ttrpg_manager;

-- Cada personaje del jugador puede tener su propio token en el escenario.
ALTER TABLE scenario_players
  ADD UNIQUE INDEX IF NOT EXISTS uq_scenario_character (scenario_id, character_id);

SET @has_old_scenario_user_unique = (
  SELECT COUNT(*)
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'scenario_players'
    AND INDEX_NAME = 'scenario_id'
    AND NON_UNIQUE = 0
    AND COLUMN_NAME = 'user_id'
);
SET @drop_old_scenario_user_unique_sql = IF(
  @has_old_scenario_user_unique > 0,
  'ALTER TABLE scenario_players DROP INDEX scenario_id',
  'DO 0'
);
PREPARE drop_old_scenario_user_unique_stmt FROM @drop_old_scenario_user_unique_sql;
EXECUTE drop_old_scenario_user_unique_stmt;
DEALLOCATE PREPARE drop_old_scenario_user_unique_stmt;

-- Las solicitudes deben identificar el token exacto cuando un usuario controla varios.
ALTER TABLE movement_requests
  ADD COLUMN IF NOT EXISTS scenario_player_id BIGINT UNSIGNED NULL AFTER user_id,
  ADD INDEX IF NOT EXISTS idx_movement_scenario_player (scenario_player_id);

UPDATE movement_requests mr
JOIN scenario_players sp
  ON sp.scenario_id = mr.scenario_id
 AND sp.user_id = mr.user_id
SET mr.scenario_player_id = sp.id
WHERE mr.scenario_player_id IS NULL;

SET @has_movement_player_fk = (
  SELECT COUNT(*)
  FROM information_schema.KEY_COLUMN_USAGE
  WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND TABLE_NAME = 'movement_requests'
    AND COLUMN_NAME = 'scenario_player_id'
    AND REFERENCED_TABLE_NAME = 'scenario_players'
);
SET @movement_player_fk_sql = IF(
  @has_movement_player_fk = 0,
  'ALTER TABLE movement_requests ADD CONSTRAINT fk_movement_scenario_player FOREIGN KEY (scenario_player_id) REFERENCES scenario_players(id) ON DELETE SET NULL',
  'DO 0'
);
PREPARE movement_player_fk_stmt FROM @movement_player_fk_sql;
EXECUTE movement_player_fk_stmt;
DEALLOCATE PREPARE movement_player_fk_stmt;
