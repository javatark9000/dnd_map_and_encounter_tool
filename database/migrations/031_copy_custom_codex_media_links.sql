USE dnd_manager;

-- Existing custom Codex records should inherit the media links of their base record.
-- This keeps custom creatures using the same portrait/token as the source creature by default.

INSERT IGNORE INTO codex_media_links(
    media_asset_id, entity_type, entity_id, media_purpose_id, visibility_level_id,
    title, caption, sort_order, is_primary
)
SELECT
    cml.media_asset_id, cml.entity_type, c.id, cml.media_purpose_id, cml.visibility_level_id,
    cml.title, cml.caption, cml.sort_order, cml.is_primary
FROM creatures c
JOIN codex_media_links cml
  ON cml.entity_type = 'creature'
 AND cml.entity_id = c.source_creature_id
WHERE c.is_custom = 1
  AND c.source_creature_id IS NOT NULL;

INSERT IGNORE INTO codex_media_links(
    media_asset_id, entity_type, entity_id, media_purpose_id, visibility_level_id,
    title, caption, sort_order, is_primary
)
SELECT
    cml.media_asset_id, cml.entity_type, i.id, cml.media_purpose_id, cml.visibility_level_id,
    cml.title, cml.caption, cml.sort_order, cml.is_primary
FROM items i
JOIN codex_media_links cml
  ON cml.entity_type = 'item'
 AND cml.entity_id = i.source_item_id
WHERE i.is_custom = 1
  AND i.source_item_id IS NOT NULL;
