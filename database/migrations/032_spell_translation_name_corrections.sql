USE dnd_manager;

-- Manual Spanish spell-name corrections for awkward literal machine translations.
-- Wikidot remains the source, but translated display names are normalized here.

UPDATE actions a
JOIN action_categories ac ON ac.id = a.action_category_id AND ac.code = 'spell'
SET a.name = CASE a.name
    WHEN 'Abi-Dalzims Horrible marchitamiento' THEN 'Marchitamiento horripilante de Abi-Dalzim'
    WHEN 'Aganazzar''s Abrasador' THEN 'Abrasador de Aganazzar'
    WHEN 'Elementos absorbentes' THEN 'Absorber elementos'
    WHEN 'Alterar el yo' THEN 'Alterar aspecto propio'
    WHEN 'Ashardalon''s Paso' THEN 'Zancada de Ashardalon'
    WHEN 'Bigby''s Mano' THEN 'Mano de Bigby'
    WHEN 'Llamar a Lightning' THEN 'Llamar al relámpago'
    WHEN 'Rayo en cadena' THEN 'Cadena de relámpagos'
    WHEN 'Conecta con la naturaleza' THEN 'Comunión con la naturaleza'
    WHEN 'Spray de color' THEN 'Rociada de color'
    WHEN 'Cruzado''s Manto' THEN 'Manto del cruzado'
    WHEN 'Disfrazarse a uno mismo' THEN 'Disfrazarse'
    WHEN 'Invocaciones instantáneas de Drawmij''s' THEN 'Convocación instantánea de Drawmij'
    WHEN 'Evard''s Tentáculos negros' THEN 'Tentáculos negros de Evard'
    WHEN 'Mejorar la capacidad' THEN 'Mejorar característica'
    WHEN 'Fizban''s Escudo Platino' THEN 'Escudo de platino de Fizban'
    WHEN 'Fortuna''s Favor' THEN 'Favor de la fortuna'
    WHEN 'Galder''s Mensajero rápido' THEN 'Mensajero veloz de Galder'
    WHEN 'Mayor invisibilidad' THEN 'Invisibilidad mayor'
    WHEN 'Mayor restauración' THEN 'Restauración mayor'
    WHEN 'Hunter''s Mark' THEN 'Marca del cazador'
    WHEN 'Jim''s Misil Mágico' THEN 'Proyectil mágico de Jim'
    WHEN 'Leomund''s Cofre secreto' THEN 'Cofre secreto de Leomund'
    WHEN 'Rayo' THEN 'Relámpago'
    WHEN 'Melf''s Flecha ácida' THEN 'Flecha ácida de Melf'
    WHEN 'Mordenkainen''s Perro fiel' THEN 'Sabueso fiel de Mordenkainen'
    WHEN 'Mordenkainen''s Magnífica Mansión' THEN 'Mansión magnífica de Mordenkainen'
    WHEN 'Mordenkainen''s Santuario privado' THEN 'Santuario privado de Mordenkainen'
    WHEN 'Espada Mordenkainen''s' THEN 'Espada de Mordenkainen'
    WHEN 'Nathair''s Travesura' THEN 'Travesura de Nathair'
    WHEN 'Nathair''s Travesura (UA)' THEN 'Travesura de Nathair (UA)'
    WHEN 'Nystul''s Aura mágica' THEN 'Aura mágica de Nystul'
    WHEN 'Passwall' THEN 'Pasamuros'
    WHEN 'Otiluke''s Esfera congelante' THEN 'Esfera congelante de Otiluke'
    WHEN 'Otiluke''s Esfera Resiliente' THEN 'Esfera resistente de Otiluke'
    WHEN 'Otto''s Baile irresistible' THEN 'Danza irresistible de Otto'
    WHEN 'Espray venenoso' THEN 'Rociada venenosa'
    WHEN 'Spray prismático' THEN 'Rociada prismática'
    WHEN 'Rary''s Vínculo telepático' THEN 'Vínculo telepático de Rary'
    WHEN 'Spray de cartas' THEN 'Ráfaga de cartas'
    WHEN 'Spray de cartas (UA)' THEN 'Ráfaga de cartas (UA)'
    WHEN 'Perdonen a los moribundos' THEN 'Piedad con los moribundos'
    WHEN 'Tasha''s Cerveza cáustica' THEN 'Brebaje cáustico de Tasha'
    WHEN 'Tasha''s Risa espantosa' THEN 'Risa espantosa de Tasha'
    WHEN 'Tasha''s Látigo mental' THEN 'Látigo mental de Tasha'
    WHEN 'Tasha''s Disfraz de otro mundo' THEN 'Apariencia sobrenatural de Tasha'
    WHEN 'Disco flotante Tenser''s' THEN 'Disco flotante de Tenser'
    ELSE a.name
END
WHERE a.name IN (
    'Abi-Dalzims Horrible marchitamiento','Aganazzar''s Abrasador','Elementos absorbentes','Alterar el yo','Ashardalon''s Paso','Bigby''s Mano',
    'Llamar a Lightning','Rayo en cadena','Conecta con la naturaleza','Spray de color','Cruzado''s Manto','Disfrazarse a uno mismo','Invocaciones instantáneas de Drawmij''s',
    'Evard''s Tentáculos negros','Mejorar la capacidad','Fizban''s Escudo Platino','Fortuna''s Favor','Galder''s Mensajero rápido',
    'Mayor invisibilidad','Mayor restauración','Hunter''s Mark','Jim''s Misil Mágico','Leomund''s Cofre secreto','Rayo',
    'Melf''s Flecha ácida','Mordenkainen''s Perro fiel','Mordenkainen''s Magnífica Mansión','Mordenkainen''s Santuario privado',
    'Espada Mordenkainen''s','Nathair''s Travesura','Nathair''s Travesura (UA)','Nystul''s Aura mágica','Passwall',
    'Otiluke''s Esfera congelante','Otiluke''s Esfera Resiliente','Otto''s Baile irresistible','Espray venenoso','Spray prismático','Rary''s Vínculo telepático','Spray de cartas','Spray de cartas (UA)',
    'Perdonen a los moribundos','Tasha''s Cerveza cáustica','Tasha''s Risa espantosa','Tasha''s Látigo mental',
    'Tasha''s Disfraz de otro mundo','Disco flotante Tenser''s'
);
