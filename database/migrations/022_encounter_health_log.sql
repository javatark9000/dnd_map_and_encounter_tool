CREATE TABLE IF NOT EXISTS encounter_health_log (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 encounter_id BIGINT UNSIGNED NOT NULL,
 round_no INT UNSIGNED NOT NULL DEFAULT 0,
 actor_type ENUM('PLAYER','NPC') NOT NULL,
 actor_id BIGINT UNSIGNED NOT NULL,
 actor_name VARCHAR(120) NOT NULL,
 action_type ENUM('DAMAGE','HEAL') NOT NULL,
 amount INT NOT NULL,
 health_before INT NOT NULL,
 health_after INT NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 INDEX(encounter_id,id),
 INDEX(encounter_id,actor_type,actor_id)
) ENGINE=InnoDB;
