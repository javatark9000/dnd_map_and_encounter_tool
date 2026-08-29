USE ttrpg_manager;

-- Remove duplicated SRD 2014 creatures when a same-name SRD 2024 creature exists.
-- Keep the 2024 creature/monster-ability data as the canonical Codex record.

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_srd_creature_dups (
    old_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    new_id BIGINT UNSIGNED NOT NULL
) ENGINE=MEMORY;

TRUNCATE TABLE tmp_srd_creature_dups;

INSERT INTO tmp_srd_creature_dups(old_id, new_id)
SELECT c2014.id, c2024.id
FROM creatures c2014
JOIN sources s2014 ON s2014.id = c2014.source_material_id AND s2014.code = 'srd_2014'
JOIN creatures c2024 ON c2024.name = c2014.name AND c2024.is_active = 1
JOIN sources s2024 ON s2024.id = c2024.source_material_id AND s2024.code = 'srd_2024'
WHERE c2014.is_active = 1;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_srd_old_actions (
    action_id BIGINT UNSIGNED NOT NULL PRIMARY KEY
) ENGINE=MEMORY;

TRUNCATE TABLE tmp_srd_old_actions;

INSERT IGNORE INTO tmp_srd_old_actions(action_id)
SELECT aa.action_id
FROM action_assignments aa
JOIN tmp_srd_creature_dups d ON d.old_id = aa.owner_id
JOIN actions a ON a.id = aa.action_id
JOIN action_categories ac ON ac.id = a.action_category_id AND ac.code = 'monster_ability'
LEFT JOIN sources src ON src.id = a.source_material_id
WHERE aa.owner_type = 'creature'
  AND (a.rules_revision = '2014' OR src.code = 'srd_2014');

-- Preserve custom lineage by pointing custom copies at the kept 2024 source record.
UPDATE creatures c
JOIN tmp_srd_creature_dups d ON d.old_id = c.source_creature_id
SET c.source_creature_id = d.new_id;

DELETE cml
FROM codex_media_links cml
JOIN tmp_srd_creature_dups d ON d.old_id = cml.entity_id
WHERE cml.entity_type = 'creature';

DELETE cml
FROM codex_media_links cml
LEFT JOIN creatures c ON c.id = cml.entity_id
WHERE cml.entity_type = 'creature'
  AND c.id IS NULL;

DELETE aa
FROM action_assignments aa
JOIN tmp_srd_creature_dups d ON d.old_id = aa.owner_id
WHERE aa.owner_type = 'creature';

DELETE a
FROM actions a
JOIN tmp_srd_old_actions oa ON oa.action_id = a.id
WHERE NOT EXISTS (
    SELECT 1 FROM action_assignments aa WHERE aa.action_id = a.id
);

DELETE c
FROM creatures c
JOIN tmp_srd_creature_dups d ON d.old_id = c.id;

DROP TEMPORARY TABLE IF EXISTS tmp_srd_old_actions;
DROP TEMPORARY TABLE IF EXISTS tmp_srd_creature_dups;
