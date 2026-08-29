USE ttrpg_manager;

START TRANSACTION;

UPDATE creatures c
JOIN visibility_levels vl ON vl.code = 'dm_only'
SET c.visibility_level_id = vl.id
WHERE c.is_active = TRUE;

UPDATE actions a
JOIN action_categories ac ON ac.id = a.action_category_id AND ac.code = 'monster_ability'
JOIN visibility_levels vl ON vl.code = 'dm_only'
SET a.visibility_level_id = vl.id
WHERE a.is_active = TRUE;

COMMIT;
