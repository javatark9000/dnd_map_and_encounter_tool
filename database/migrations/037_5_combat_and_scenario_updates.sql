USE ttrpg_manager;

-- Ocultado lógico de escenarios y soporte para las consultas del listado.
ALTER TABLE scenarios
  ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN NOT NULL DEFAULT FALSE AFTER active,
  ADD INDEX IF NOT EXISTS idx_scenarios_visibility (campaign_id, is_deleted, active, name);

-- La vida máxima no se almacenaba antes. Para los NPC existentes, la mejor
-- referencia disponible es su vida actual al momento de aplicar la migración.
ALTER TABLE npc_characters
  ADD COLUMN IF NOT EXISTS max_health INT NULL AFTER health;

UPDATE npc_characters
SET max_health = health
WHERE max_health IS NULL;

-- Color configurable para cada ficha de personaje.
ALTER TABLE scenario_players
  ADD COLUMN IF NOT EXISTS token_color VARCHAR(20) NULL AFTER health;

-- Historial necesario para devolver o reiniciar turnos del combate.
CREATE TABLE IF NOT EXISTS encounter_turn_history (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  encounter_id BIGINT UNSIGNED NOT NULL,
  previous_participant_id BIGINT UNSIGNED NULL,
  previous_round_no INT UNSIGNED NOT NULL,
  previous_turn_sequence INT UNSIGNED NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (encounter_id) REFERENCES encounters(id) ON DELETE CASCADE,
  FOREIGN KEY (previous_participant_id) REFERENCES encounter_participants(id) ON DELETE SET NULL,
  INDEX idx_encounter_turn_history_lookup (encounter_id, id)
) ENGINE=InnoDB;
