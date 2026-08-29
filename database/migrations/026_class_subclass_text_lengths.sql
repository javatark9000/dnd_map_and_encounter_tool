USE dnd_manager;

ALTER TABLE classes
 MODIFY COLUMN short_description TEXT NULL,
 MODIFY COLUMN hit_die_text TEXT NULL,
 MODIFY COLUMN primary_ability_text TEXT NULL,
 MODIFY COLUMN saving_throw_proficiencies_text TEXT NULL,
 MODIFY COLUMN armor_proficiencies_text TEXT NULL,
 MODIFY COLUMN weapon_proficiencies_text TEXT NULL,
 MODIFY COLUMN tool_proficiencies_text TEXT NULL,
 MODIFY COLUMN skill_proficiencies_text TEXT NULL;

ALTER TABLE subclasses
 MODIFY COLUMN short_description TEXT NULL,
 MODIFY COLUMN subclass_type_text TEXT NULL;
