CREATE TABLE IF NOT EXISTS encounter_turn_history (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  encounter_id BIGINT UNSIGNED NOT NULL,
  previous_participant_id BIGINT UNSIGNED NULL,
  previous_round_no INT UNSIGNED NOT NULL,
  previous_turn_sequence INT UNSIGNED NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (encounter_id) REFERENCES encounters(id) ON DELETE CASCADE,
  FOREIGN KEY (previous_participant_id) REFERENCES encounter_participants(id) ON DELETE SET NULL,
  INDEX(encounter_id,id)
) ENGINE=InnoDB;
