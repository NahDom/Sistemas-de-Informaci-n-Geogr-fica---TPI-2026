-- =====================================================================
-- 03 · Capa editable para la aplicación web (alta de elementos vía WFS-T)
-- =====================================================================

CREATE TABLE IF NOT EXISTS incidencias_ruta (
  id          serial PRIMARY KEY,
  tipo        varchar(50),     -- Bache | Señalización dañada | Banquina deteriorada | Otro
  descripcion varchar(255),
  fecha       date DEFAULT current_date,
  geom        geometry(Point, 4326)
);

CREATE INDEX IF NOT EXISTS incidencias_ruta_geom_idx
  ON incidencias_ruta USING gist (geom);

-- Ver lo cargado desde la aplicación web
SELECT id, tipo, descripcion, fecha, ST_AsText(geom) AS ubicacion
FROM incidencias_ruta
ORDER BY id;
