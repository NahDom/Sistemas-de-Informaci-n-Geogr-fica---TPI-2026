-- =====================================================================
-- 04 · Consultas de verificación
-- =====================================================================

-- Capas espaciales cargadas (tipo de geometría y SRID)
SELECT f_table_name AS tabla, type AS geometria, srid
FROM geometry_columns
ORDER BY 1;

-- Cantidad de capas
SELECT count(*) AS capas FROM geometry_columns;

-- Valores usados para clasificar los estilos SLD
SELECT 'red_vial.administra' AS campo, administra AS valor, count(*) FROM red_vial GROUP BY administra
UNION ALL SELECT 'localidades.tipo', tipo, count(*) FROM localidades GROUP BY tipo
UNION ALL SELECT 'puentes.tipo', tipo, count(*) FROM puente_red_vial_puntos GROUP BY tipo
ORDER BY 1, 3 DESC;
