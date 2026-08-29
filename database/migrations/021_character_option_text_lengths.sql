USE ttrpg_manager;

ALTER TABLE feats
 MODIFY COLUMN short_description TEXT NULL;

ALTER TABLE species
 MODIFY COLUMN short_description TEXT NULL;

ALTER TABLE subspecies
 MODIFY COLUMN short_description TEXT NULL;

ALTER TABLE backgrounds
 MODIFY COLUMN short_description TEXT NULL;

ALTER TABLE background_variants
 MODIFY COLUMN short_description TEXT NULL;
