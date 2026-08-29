USE ttrpg_manager;

-- Remove duplicated SRD 2014 actions when a same-name/same-category SRD 2024 action exists.
-- Keep 2024 records as canonical. Monster abilities are only considered duplicates when
-- they belong to same-name SRD 2014/2024 creature pairs; generic ability names like
-- "Ataque múltiple" on different monsters are intentionally preserved.

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_srd_action_dups (
    old_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    new_id BIGINT UNSIGNED NOT NULL
) ENGINE=MEMORY;

TRUNCATE TABLE tmp_srd_action_dups;

-- Spells/general abilities: same action category + same name across SRD revisions.
INSERT IGNORE INTO tmp_srd_action_dups(old_id, new_id)
SELECT a2014.id, MIN(a2024.id) AS new_id
FROM actions a2014
JOIN sources s2014 ON s2014.id = a2014.source_material_id AND s2014.code = 'srd_2014'
JOIN action_categories ac ON ac.id = a2014.action_category_id AND ac.code <> 'monster_ability'
JOIN actions a2024
  ON a2024.action_category_id = a2014.action_category_id
 AND a2024.name = a2014.name
 AND a2024.is_active = 1
JOIN sources s2024 ON s2024.id = a2024.source_material_id AND s2024.code = 'srd_2024'
WHERE a2014.is_active = 1
GROUP BY a2014.id;

-- Monster abilities: only duplicate if their owning creatures are a same-name SRD pair.
INSERT IGNORE INTO tmp_srd_action_dups(old_id, new_id)
SELECT a2014.id, MIN(a2024.id) AS new_id
FROM actions a2014
JOIN sources s2014 ON s2014.id = a2014.source_material_id AND s2014.code = 'srd_2014'
JOIN action_categories ac ON ac.id = a2014.action_category_id AND ac.code = 'monster_ability'
JOIN action_assignments aa2014 ON aa2014.action_id = a2014.id AND aa2014.owner_type = 'creature'
JOIN creatures c2014 ON c2014.id = aa2014.owner_id
JOIN sources cs2014 ON cs2014.id = c2014.source_material_id AND cs2014.code = 'srd_2014'
JOIN creatures c2024 ON c2024.name = c2014.name AND c2024.is_active = 1
JOIN sources cs2024 ON cs2024.id = c2024.source_material_id AND cs2024.code = 'srd_2024'
JOIN action_assignments aa2024 ON aa2024.owner_type = 'creature' AND aa2024.owner_id = c2024.id
JOIN actions a2024 ON a2024.id = aa2024.action_id
    AND a2024.action_category_id = a2014.action_category_id
    AND a2024.name = a2014.name
    AND a2024.is_active = 1
JOIN sources s2024 ON s2024.id = a2024.source_material_id AND s2024.code = 'srd_2024'
WHERE a2014.is_active = 1
GROUP BY a2014.id;

-- Preserve custom lineage by pointing custom copies at the kept 2024 source action.
UPDATE actions a
JOIN tmp_srd_action_dups d ON d.old_id = a.source_action_id
SET a.source_action_id = d.new_id;

-- Copy assignments to the kept record if they do not already exist there.
INSERT IGNORE INTO action_assignments(action_id, owner_type, owner_id, notes)
SELECT d.new_id, aa.owner_type, aa.owner_id, aa.notes
FROM action_assignments aa
JOIN tmp_srd_action_dups d ON d.old_id = aa.action_id;

DELETE aa
FROM action_assignments aa
JOIN tmp_srd_action_dups d ON d.old_id = aa.action_id;

DELETE atg
FROM action_tags atg
JOIN tmp_srd_action_dups d ON d.old_id = atg.action_id;

DELETE aca
FROM action_class_availability aca
JOIN tmp_srd_action_dups d ON d.old_id = aca.action_id;

DELETE a
FROM actions a
JOIN tmp_srd_action_dups d ON d.old_id = a.id;

DROP TEMPORARY TABLE IF EXISTS tmp_srd_action_dups;
