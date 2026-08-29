USE ttrpg_manager;

START TRANSACTION;

CREATE TEMPORARY TABLE IF NOT EXISTS dragonlance_items AS
SELECT id FROM items
WHERE LOWER(CONCAT_WS(' ', name, short_description, description, properties_text, requirements_text, source_page_text)) LIKE '%dragonlance%';

CREATE TEMPORARY TABLE IF NOT EXISTS dragonlance_feats AS
SELECT id FROM feats
WHERE LOWER(CONCAT_WS(' ', name, short_description, description, prerequisites_text, benefits_text, source_page_text)) LIKE '%dragonlance%';

CREATE TEMPORARY TABLE IF NOT EXISTS dragonlance_subspecies AS
SELECT id FROM subspecies
WHERE LOWER(CONCAT_WS(' ', name, short_description, description, lineage_type_code, traits_text, source_page_text, source_url)) LIKE '%dragonlance%';

CREATE TEMPORARY TABLE IF NOT EXISTS dragonlance_backgrounds AS
SELECT id FROM backgrounds
WHERE LOWER(CONCAT_WS(' ', name, short_description, description, background_type_code, setting_name, feature_text, source_page_text, source_url)) LIKE '%dragonlance%';

CREATE TEMPORARY TABLE IF NOT EXISTS dragonlance_background_variants AS
SELECT id FROM background_variants
WHERE background_id IN (SELECT id FROM dragonlance_backgrounds)
   OR LOWER(CONCAT_WS(' ', name, short_description, description, background_type_code, setting_name, feature_text, source_page_text, source_url)) LIKE '%dragonlance%';

CREATE TEMPORARY TABLE IF NOT EXISTS dragonlance_classes AS
SELECT id FROM classes WHERE 1=0;

CREATE TEMPORARY TABLE IF NOT EXISTS dragonlance_subclasses AS
SELECT id FROM subclasses
WHERE class_id IN (SELECT id FROM dragonlance_classes)
   OR LOWER(CONCAT_WS(' ', name, short_description, description, subclass_type_text, requirements_text, source_page_text)) LIKE '%dragonlance%';

DELETE FROM codex_record_tags WHERE owner_type='item' AND owner_id IN (SELECT id FROM dragonlance_items);
DELETE FROM item_weapon_properties WHERE item_id IN (SELECT id FROM dragonlance_items);
DELETE FROM item_poison_types WHERE item_id IN (SELECT id FROM dragonlance_items);
UPDATE items SET source_item_id = NULL WHERE source_item_id IN (SELECT id FROM dragonlance_items);
DELETE FROM items WHERE id IN (SELECT id FROM dragonlance_items);

DELETE FROM codex_record_tags WHERE owner_type='feat' AND owner_id IN (SELECT id FROM dragonlance_feats);
UPDATE feats SET source_feat_id = NULL WHERE source_feat_id IN (SELECT id FROM dragonlance_feats);
DELETE FROM feats WHERE id IN (SELECT id FROM dragonlance_feats);

DELETE FROM codex_record_tags WHERE owner_type='subspecies' AND owner_id IN (SELECT id FROM dragonlance_subspecies);
UPDATE subspecies SET source_subspecies_id = NULL WHERE source_subspecies_id IN (SELECT id FROM dragonlance_subspecies);
DELETE FROM subspecies WHERE id IN (SELECT id FROM dragonlance_subspecies);

DELETE FROM codex_record_tags WHERE owner_type='background_variant' AND owner_id IN (SELECT id FROM dragonlance_background_variants);
UPDATE background_variants SET source_background_variant_id = NULL WHERE source_background_variant_id IN (SELECT id FROM dragonlance_background_variants);
DELETE FROM background_variants WHERE id IN (SELECT id FROM dragonlance_background_variants);

DELETE FROM codex_record_tags WHERE owner_type='background' AND owner_id IN (SELECT id FROM dragonlance_backgrounds);
UPDATE backgrounds SET source_background_id = NULL WHERE source_background_id IN (SELECT id FROM dragonlance_backgrounds);
DELETE FROM backgrounds WHERE id IN (SELECT id FROM dragonlance_backgrounds);

DELETE FROM codex_record_tags WHERE owner_type='subclass' AND owner_id IN (SELECT id FROM dragonlance_subclasses);
UPDATE subclasses SET source_subclass_id = NULL WHERE source_subclass_id IN (SELECT id FROM dragonlance_subclasses);
DELETE FROM subclasses WHERE id IN (SELECT id FROM dragonlance_subclasses);

UPDATE classes SET description = REPLACE(description, 'Dragonlance', 'otros mundos') WHERE description LIKE '%Dragonlance%';

COMMIT;
