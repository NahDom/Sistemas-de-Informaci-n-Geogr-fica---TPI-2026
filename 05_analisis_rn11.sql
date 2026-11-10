-- =====================================================================
-- Parte b: análisis de la Ruta Nacional 11 en la provincia del Chaco
-- =====================================================================

-- ---------------------------------------------------------------------
-- b.0 · Identificación: rutas nacionales en el Chaco
-- (la RN 11 figura como nro_ruta = '11'; existe también una ruta
--  PROVINCIAL 11, por eso se filtra además por administra = 'Nacional')
-- ---------------------------------------------------------------------
SELECT r.administra, r.tipo, count(*) AS tramos,
       round(sum(ST_Length(ST_Intersection(r.geom, p.geom)::geography)) / 1000) AS km
FROM red_vial r
JOIN provincias p ON ST_Intersects(r.geom, p.geom)
WHERE p.provincia ILIKE '%chaco%' AND r.nro_ruta = '11'
GROUP BY 1, 2;

-- ---------------------------------------------------------------------
-- b.1 · Traza de la RN 11 recortada al Chaco y su longitud
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS rn11_chaco;
CREATE TABLE rn11_chaco AS
SELECT 1 AS id,
       'RN 11 - tramo Chaco'::varchar AS nombre,
       ST_Multi(ST_LineMerge(ST_Union(
         ST_CollectionExtract(ST_Intersection(r.geom, p.geom), 2)
       )))::geometry(MultiLineString, 4326) AS geom
FROM red_vial r
JOIN provincias p ON ST_Intersects(r.geom, p.geom)
WHERE p.provincia ILIKE '%chaco%'
  AND r.nro_ruta = '11'
  AND r.administra = 'Nacional';

ALTER TABLE rn11_chaco ADD PRIMARY KEY (id);
CREATE INDEX ON rn11_chaco USING gist (geom);

-- Longitud geodésica (elipsoide WGS84) y en POSGAR 2007 faja 5 (EPSG:5347)
-- Resultado: 172,37 km / 172,39 km
SELECT round((ST_Length(geom::geography) / 1000)::numeric, 2)          AS km_geodesicos,
       round((ST_Length(ST_Transform(geom, 5347)) / 1000)::numeric, 2) AS km_posgar07_faja5
FROM rn11_chaco;

-- ---------------------------------------------------------------------
-- b.2 · Áreas de influencia (10 km y 10–20 km, excluyentes) y población
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS rn11_areas_influencia;
CREATE TABLE rn11_areas_influencia AS
WITH ruta  AS (SELECT ST_Transform(geom, 5347) AS g FROM rn11_chaco),
     chaco AS (SELECT ST_Transform(ST_Union(geom), 5347) AS g FROM provincias WHERE provincia ILIKE '%chaco%'),
     buf   AS (SELECT ST_Buffer(ruta.g, 10000, 'quad_segs=32') AS b10,
                      ST_Buffer(ruta.g, 20000, 'quad_segs=32') AS b20 FROM ruta)
SELECT 1 AS id, 'Hasta 10 km'::varchar AS categoria,
       ST_Multi(ST_CollectionExtract(ST_Transform(ST_Intersection(buf.b10, chaco.g), 4326), 3))::geometry(MultiPolygon, 4326) AS geom
FROM buf, chaco
UNION ALL
SELECT 2, 'Entre 10 y 20 km',
       ST_Multi(ST_CollectionExtract(ST_Transform(ST_Intersection(ST_Difference(buf.b20, buf.b10), chaco.g), 4326), 3))::geometry(MultiPolygon, 4326)
FROM buf, chaco;

ALTER TABLE rn11_areas_influencia ADD PRIMARY KEY (id);
CREATE INDEX ON rn11_areas_influencia USING gist (geom);

SELECT categoria, round((ST_Area(geom::geography) / 1e6)::numeric, 1) AS superficie_km2
FROM rn11_areas_influencia ORDER BY id;

-- Localidades afectadas, clasificadas por distancia geodésica exacta a la traza
-- (los buffers se usan para la representación en el mapa)
DROP TABLE IF EXISTS rn11_localidades_afectadas;
CREATE TABLE rn11_localidades_afectadas AS
SELECT l.id, l.nombre, l.tipo, l.departamen AS departamento, l.canthab,
       round((x.d / 1000)::numeric, 2) AS dist_km,
       CASE WHEN x.d <= 10000 THEN 'Hasta 10 km' ELSE 'Entre 10 y 20 km' END AS categoria,
       l.geom
FROM localidades l
CROSS JOIN rn11_chaco r
CROSS JOIN LATERAL (SELECT ST_Distance(l.geom::geography, r.geom::geography) AS d) x
WHERE l.provincia ILIKE '%chaco%'
  AND x.d <= 20000;

ALTER TABLE rn11_localidades_afectadas ADD PRIMARY KEY (id);

-- Resultado: hasta 10 km = 22 localidades / 363.320 hab.
--            10 a 20 km  = 15 localidades /  26.080 hab.
SELECT categoria, count(*) AS localidades, sum(canthab) AS poblacion
FROM rn11_localidades_afectadas
GROUP BY categoria
ORDER BY min(dist_km);

SELECT categoria, nombre, tipo, departamento, canthab, dist_km
FROM rn11_localidades_afectadas
ORDER BY dist_km;

-- ---------------------------------------------------------------------
-- b.3 · Puentes sobre la traza (tolerancia 200 m, acorde a la escala 1:250.000)
-- ---------------------------------------------------------------------
-- Exploración de distancias (corte natural entre 156 m y 286 m)
SELECT p.id, p.tipo, p.material,
       round(ST_Distance(p.geom::geography, r.geom::geography)::numeric, 1) AS dist_m
FROM puente_red_vial_puntos p
CROSS JOIN rn11_chaco r
WHERE ST_DWithin(p.geom::geography, r.geom::geography, 1000)
ORDER BY dist_m;

DROP TABLE IF EXISTS rn11_puentes;
CREATE TABLE rn11_puentes AS
WITH ruta AS (
  SELECT ST_LineMerge(geom) AS g, ST_Length(geom::geography) AS largo_m FROM rn11_chaco
)
SELECT p.id AS id_ign, p.tipo, p.material,
       round(ST_Distance(p.geom::geography, ruta.g::geography)::numeric, 1) AS dist_m,
       CASE WHEN GeometryType(ruta.g) = 'LINESTRING'
            THEN round((ST_LineLocatePoint(ruta.g, ST_ClosestPoint(ruta.g, ST_GeometryN(p.geom, 1))) * ruta.largo_m / 1000)::numeric, 1)
       END AS progresiva_km,
       loc.nombre AS localidad_cercana,
       round(ST_X(ST_GeometryN(p.geom, 1))::numeric, 5) AS lon,
       round(ST_Y(ST_GeometryN(p.geom, 1))::numeric, 5) AS lat,
       p.geom
FROM puente_red_vial_puntos p
CROSS JOIN ruta
LEFT JOIN LATERAL (
  SELECT l.nombre FROM localidades l
  WHERE l.provincia ILIKE '%chaco%' AND l.tipo <> 'Lugar o Paraje'
  ORDER BY l.geom <-> p.geom LIMIT 1
) loc ON true
WHERE ST_DWithin(p.geom::geography, ruta.g::geography, 200);

ALTER TABLE rn11_puentes ADD PRIMARY KEY (id_ign);

-- Resultado: 21 puentes
SELECT count(*) AS cantidad_puentes FROM rn11_puentes;

SELECT row_number() OVER (ORDER BY progresiva_km, lat) AS nro,
       progresiva_km, localidad_cercana, tipo, material, dist_m, lon, lat, id_ign
FROM rn11_puentes
ORDER BY progresiva_km, lat;


