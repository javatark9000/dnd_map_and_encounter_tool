USE ttrpg_manager;

-- Merge mechanically identical non-custom monster abilities into one shared action record.
-- The owning creatures remain linked through action_assignments.
-- Grouping intentionally includes source/rules revision to avoid misleading source labels.

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_identical_monster_action_sig (
    action_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    sig CHAR(32) NOT NULL,
    KEY idx_tmp_identical_monster_action_sig_sig (sig)
) ENGINE=InnoDB;

TRUNCATE TABLE tmp_identical_monster_action_sig;

INSERT INTO tmp_identical_monster_action_sig(action_id, sig)
SELECT a.id,
       MD5(CONCAT_WS('|',
           a.system_id,
           a.action_category_id,
           COALESCE(a.activation_type_id, 0),
           COALESCE(a.source_material_id, 0),
           COALESCE(a.rules_revision, ''),
           COALESCE(a.name, ''),
           COALESCE(a.description, ''),
           COALESCE(a.damage_text, ''),
           COALESCE(a.attack_bonus, ''),
           COALESCE(a.difficulty_class_text, ''),
           COALESCE(a.usage_text, ''),
           COALESCE(a.legendary_cost, ''),
           COALESCE(a.range_text, ''),
           COALESCE(a.duration_text, ''),
           COALESCE(a.components_text, ''),
           COALESCE(a.resource_cost_text, '')
       )) AS sig
FROM actions a
JOIN action_categories ac ON ac.id = a.action_category_id AND ac.code = 'monster_ability'
WHERE a.is_active = 1
  AND a.is_custom = 0;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_identical_monster_action_keep (
    sig CHAR(32) NOT NULL PRIMARY KEY,
    keep_id BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB;

TRUNCATE TABLE tmp_identical_monster_action_keep;

INSERT INTO tmp_identical_monster_action_keep(sig, keep_id)
SELECT sig, MIN(action_id) AS keep_id
FROM tmp_identical_monster_action_sig
GROUP BY sig
HAVING COUNT(*) > 1;

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_identical_monster_action_dups (
    old_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    keep_id BIGINT UNSIGNED NOT NULL,
    KEY idx_tmp_identical_monster_action_dups_keep (keep_id)
) ENGINE=InnoDB;

TRUNCATE TABLE tmp_identical_monster_action_dups;

INSERT INTO tmp_identical_monster_action_dups(old_id, keep_id)
SELECT s.action_id, k.keep_id
FROM tmp_identical_monster_action_sig s
JOIN tmp_identical_monster_action_keep k ON k.sig = s.sig
WHERE s.action_id <> k.keep_id;

-- Preserve custom lineage if any custom action was copied from a soon-to-be-merged duplicate.
UPDATE actions a
JOIN tmp_identical_monster_action_dups d ON d.old_id = a.source_action_id
SET a.source_action_id = d.keep_id;

-- Move creature assignments to the kept shared action.
INSERT IGNORE INTO action_assignments(action_id, owner_type, owner_id, notes)
SELECT d.keep_id, aa.owner_type, aa.owner_id, aa.notes
FROM action_assignments aa
JOIN tmp_identical_monster_action_dups d ON d.old_id = aa.action_id;

-- Preserve tags/availability just in case any duplicated action has them.
INSERT IGNORE INTO action_tags(action_id, tag_id)
SELECT d.keep_id, atg.tag_id
FROM action_tags atg
JOIN tmp_identical_monster_action_dups d ON d.old_id = atg.action_id;

INSERT IGNORE INTO action_class_availability(action_id, class_id, notes)
SELECT d.keep_id, aca.class_id, aca.notes
FROM action_class_availability aca
JOIN tmp_identical_monster_action_dups d ON d.old_id = aca.action_id;

DELETE aa
FROM action_assignments aa
JOIN tmp_identical_monster_action_dups d ON d.old_id = aa.action_id;

DELETE atg
FROM action_tags atg
JOIN tmp_identical_monster_action_dups d ON d.old_id = atg.action_id;

DELETE aca
FROM action_class_availability aca
JOIN tmp_identical_monster_action_dups d ON d.old_id = aca.action_id;

DELETE a
FROM actions a
JOIN tmp_identical_monster_action_dups d ON d.old_id = a.id;

DROP TEMPORARY TABLE IF EXISTS tmp_identical_monster_action_dups;
DROP TEMPORARY TABLE IF EXISTS tmp_identical_monster_action_keep;
DROP TEMPORARY TABLE IF EXISTS tmp_identical_monster_action_sig;
