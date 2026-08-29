USE ttrpg_manager;

ALTER TABLE species
 MODIFY COLUMN size_text TEXT NULL,
 MODIFY COLUMN speed_text TEXT NULL,
 MODIFY COLUMN languages_text TEXT NULL,
 MODIFY COLUMN ability_score_text TEXT NULL,
 MODIFY COLUMN creature_type_text TEXT NULL,
 MODIFY COLUMN age_text TEXT NULL,
 MODIFY COLUMN alignment_text TEXT NULL;

ALTER TABLE subspecies
 MODIFY COLUMN size_text TEXT NULL,
 MODIFY COLUMN speed_text TEXT NULL,
 MODIFY COLUMN languages_text TEXT NULL,
 MODIFY COLUMN ability_score_text TEXT NULL,
 MODIFY COLUMN creature_type_text TEXT NULL,
 MODIFY COLUMN age_text TEXT NULL,
 MODIFY COLUMN alignment_text TEXT NULL;

ALTER TABLE backgrounds
 MODIFY COLUMN skill_proficiencies_text TEXT NULL,
 MODIFY COLUMN tool_proficiencies_text TEXT NULL,
 MODIFY COLUMN languages_text TEXT NULL;

ALTER TABLE background_variants
 MODIFY COLUMN skill_proficiencies_text TEXT NULL,
 MODIFY COLUMN tool_proficiencies_text TEXT NULL,
 MODIFY COLUMN languages_text TEXT NULL;
