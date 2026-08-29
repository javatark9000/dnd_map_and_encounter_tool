USE ttrpg_manager;

-- This migration can run before the optional private wondrous-item seed.
CREATE TABLE IF NOT EXISTS scraped_wondrous_items (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 category_name VARCHAR(160) NOT NULL,
 item_name VARCHAR(180) NOT NULL,
 rarity VARCHAR(80) NOT NULL,
 rarity_code VARCHAR(80) NOT NULL,
 item_type VARCHAR(120) NULL,
 item_type_code VARCHAR(80) NOT NULL,
 attunement_text VARCHAR(255) NULL,
 requires_attunement BOOLEAN NOT NULL DEFAULT FALSE,
 book_source VARCHAR(180) NULL,
 source_code VARCHAR(40) NULL,
 source_url VARCHAR(500) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_scraped_wondrous_items (item_name, source_code, rarity_code)
) ENGINE=InnoDB;

UPDATE item_types SET name = CASE code
 WHEN 'adventuring_gear' THEN 'Equipo de aventura'
 WHEN 'ammunition' THEN 'Munición'
 WHEN 'armor' THEN 'Armadura'
 WHEN 'explosive' THEN 'Explosivo'
 WHEN 'poison' THEN 'Veneno'
 WHEN 'potion' THEN 'Poción'
 WHEN 'quest_item' THEN 'Objeto de misión'
 WHEN 'ring' THEN 'Anillo'
 WHEN 'rod' THEN 'Vara'
 WHEN 'scroll' THEN 'Pergamino'
 WHEN 'shield' THEN 'Escudo'
 WHEN 'staff' THEN 'Bastón'
 WHEN 'tool' THEN 'Herramienta'
 WHEN 'treasure' THEN 'Tesoro'
 WHEN 'wand' THEN 'Varita'
 WHEN 'weapon' THEN 'Arma'
 WHEN 'wondrous_item' THEN 'Objeto maravilloso'
 ELSE name END
WHERE code IN ('adventuring_gear','ammunition','armor','explosive','poison','potion','quest_item','ring','rod','scroll','shield','staff','tool','treasure','wand','weapon','wondrous_item');

UPDATE item_rarities SET name = CASE code
 WHEN 'common' THEN 'Común'
 WHEN 'uncommon' THEN 'Poco común'
 WHEN 'rare' THEN 'Raro'
 WHEN 'very_rare' THEN 'Muy raro'
 WHEN 'legendary' THEN 'Legendario'
 WHEN 'artifact' THEN 'Artefacto'
 WHEN 'unknown' THEN 'Desconocido'
 ELSE name END
WHERE code IN ('common','uncommon','rare','very_rare','legendary','artifact','unknown');

UPDATE items i
JOIN scraped_wondrous_items swi ON swi.item_name = i.name
JOIN systems sys ON sys.id = i.system_id AND sys.code = 'dnd_5e'
LEFT JOIN item_types typ ON typ.system_id = sys.id AND typ.code = CASE LOWER(swi.item_type_code)
 WHEN 'wondrous_item' THEN 'wondrous_item'
 WHEN 'artículo maravilloso' THEN 'wondrous_item'
 WHEN 'wondrous item' THEN 'wondrous_item'
 WHEN 'weapon' THEN 'weapon'
 WHEN 'arma' THEN 'weapon'
 WHEN 'armor' THEN 'armor'
 WHEN 'armadura' THEN 'armor'
 WHEN 'potion' THEN 'potion'
 WHEN 'poción' THEN 'potion'
 WHEN 'ring' THEN 'ring'
 WHEN 'anillo' THEN 'ring'
 WHEN 'staff' THEN 'staff'
 WHEN 'personal' THEN 'staff'
 WHEN 'bastón' THEN 'staff'
 WHEN 'wand' THEN 'wand'
 WHEN 'varita mágica' THEN 'wand'
 WHEN 'varita' THEN 'wand'
 WHEN 'rod' THEN 'rod'
 WHEN 'vara' THEN 'rod'
 WHEN 'scroll' THEN 'scroll'
 WHEN 'voluta' THEN 'scroll'
 WHEN 'pergamino' THEN 'scroll'
 ELSE 'wondrous_item' END
LEFT JOIN item_rarities rar ON rar.system_id = sys.id AND rar.code = CASE LOWER(swi.rarity_code)
 WHEN 'common' THEN 'common'
 WHEN 'común' THEN 'common'
 WHEN 'uncommon' THEN 'uncommon'
 WHEN 'poco común' THEN 'uncommon'
 WHEN 'rare' THEN 'rare'
 WHEN 'extraño' THEN 'rare'
 WHEN 'raro' THEN 'rare'
 WHEN 'very_rare' THEN 'very_rare'
 WHEN 'muy_raro' THEN 'very_rare'
 WHEN 'muy raro' THEN 'very_rare'
 WHEN 'legendary' THEN 'legendary'
 WHEN 'legendario' THEN 'legendary'
 WHEN 'artifact' THEN 'artifact'
 WHEN 'artefacto' THEN 'artifact'
 WHEN 'unknown' THEN 'unknown'
 WHEN 'desconocido' THEN 'unknown'
 ELSE 'unknown' END
SET i.item_type_id = typ.id,
    i.item_rarity_id = rar.id,
    i.short_description = CONCAT(COALESCE(rar.name, swi.rarity), ' ', COALESCE(typ.name, swi.item_type, 'Objeto mágico')),
    i.description = CONCAT('Categoría: ', swi.category_name, '\nRareza: ', COALESCE(rar.name, swi.rarity), '\nTipo: ', COALESCE(typ.name, swi.item_type, ''), '\nSintonización: ', CASE WHEN swi.requires_attunement THEN 'Requerida' ELSE 'No requerida' END, '\nFuente: ', COALESCE(swi.book_source, swi.source_code, '')),
    i.properties_text = CONCAT('Código de fuente: ', COALESCE(swi.source_code, ''))
WHERE i.is_magical = TRUE;
