USE dnd_manager;

-- Fuse duplicate non-custom species records that only differ by source/import row.
-- Keeps the first active non-custom record per name, preferring a non-null source.

CREATE TEMPORARY TABLE tmp_species_keep AS
SELECT id old_id,
       FIRST_VALUE(id) OVER (PARTITION BY name ORDER BY (source_material_id IS NULL), id) keep_id
FROM species
WHERE is_active = 1 AND is_custom = 0;

DELETE FROM tmp_species_keep WHERE old_id = keep_id;

-- Preserve tags from removed duplicate rows on the kept species.
INSERT IGNORE INTO codex_record_tags(owner_type, owner_id, tag_id)
SELECT 'species', d.keep_id, crt.tag_id
FROM tmp_species_keep d
JOIN codex_record_tags crt ON crt.owner_type = 'species' AND crt.owner_id = d.old_id;

-- Repoint subspecies and custom lineage references.
UPDATE subspecies ss
JOIN tmp_species_keep d ON d.old_id = ss.species_id
SET ss.species_id = d.keep_id;

UPDATE species s
JOIN tmp_species_keep d ON d.old_id = s.source_species_id
SET s.source_species_id = d.keep_id;

-- Remove duplicate species tag rows and duplicate species records.
DELETE crt FROM codex_record_tags crt
JOIN tmp_species_keep d ON d.old_id = crt.owner_id
WHERE crt.owner_type = 'species';

DELETE s FROM species s
JOIN tmp_species_keep d ON d.old_id = s.id;

DROP TEMPORARY TABLE IF EXISTS tmp_species_keep;
