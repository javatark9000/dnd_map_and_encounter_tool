USE ttrpg_manager;

UPDATE action_categories SET name = CASE code
 WHEN 'spell' THEN 'Hechizo'
 WHEN 'class_feature' THEN 'Rasgo de clase'
 WHEN 'racial_trait' THEN 'Rasgo de especie'
 WHEN 'monster_ability' THEN 'Habilidad de monstruo'
 WHEN 'item_ability' THEN 'Habilidad de objeto'
 WHEN 'general_ability' THEN 'Habilidad general'
 ELSE name END
WHERE code IN ('spell','class_feature','racial_trait','monster_ability','item_ability','general_ability');

UPDATE activation_types SET name = CASE code
 WHEN 'action' THEN 'Acción'
 WHEN 'bonus_action' THEN 'Acción adicional'
 WHEN 'reaction' THEN 'Reacción'
 WHEN 'free_action' THEN 'Acción libre'
 WHEN 'passive' THEN 'Pasiva'
 WHEN 'special' THEN 'Especial'
 WHEN 'short_rest' THEN 'Descanso corto'
 WHEN 'long_rest' THEN 'Descanso largo'
 ELSE name END
WHERE code IN ('action','bonus_action','reaction','free_action','passive','special','short_rest','long_rest');

UPDATE creature_sizes SET name = CASE code
 WHEN 'tiny' THEN 'Diminuto'
 WHEN 'small' THEN 'Pequeño'
 WHEN 'medium' THEN 'Mediano'
 WHEN 'large' THEN 'Grande'
 WHEN 'huge' THEN 'Enorme'
 WHEN 'gargantuan' THEN 'Gargantuesco'
 ELSE name END
WHERE code IN ('tiny','small','medium','large','huge','gargantuan');

UPDATE creature_types SET name = CASE code
 WHEN 'aberration' THEN 'Aberración'
 WHEN 'beast' THEN 'Bestia'
 WHEN 'celestial' THEN 'Celestial'
 WHEN 'construct' THEN 'Constructo'
 WHEN 'dragon' THEN 'Dragón'
 WHEN 'elemental' THEN 'Elemental'
 WHEN 'fey' THEN 'Feérico'
 WHEN 'fiend' THEN 'Infernal'
 WHEN 'giant' THEN 'Gigante'
 WHEN 'humanoid' THEN 'Humanoide'
 WHEN 'monstrosity' THEN 'Monstruosidad'
 WHEN 'ooze' THEN 'Cieno'
 WHEN 'plant' THEN 'Planta'
 WHEN 'swarm_of_tiny_beasts' THEN 'Enjambre de bestias diminutas'
 WHEN 'undead' THEN 'No muerto'
 ELSE name END
WHERE code IN ('aberration','beast','celestial','construct','dragon','elemental','fey','fiend','giant','humanoid','monstrosity','ooze','plant','swarm_of_tiny_beasts','undead');
