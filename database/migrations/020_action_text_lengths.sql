USE dnd_manager;

ALTER TABLE actions
 MODIFY COLUMN short_description TEXT NULL,
 MODIFY COLUMN range_text TEXT NULL,
 MODIFY COLUMN duration_text TEXT NULL,
 MODIFY COLUMN damage_text TEXT NULL,
 MODIFY COLUMN difficulty_class_text TEXT NULL,
 MODIFY COLUMN healing_text TEXT NULL,
 MODIFY COLUMN components_text TEXT NULL,
 MODIFY COLUMN resource_cost_text TEXT NULL,
 MODIFY COLUMN usage_text TEXT NULL;
