-- =====================================================================
-- 02 · Normalización de nombres (después de cargar las capas SIG 250)
-- Los nombres con acentos, ñ o mayúsculas generan errores en los filtros
-- WFS, en las consultas desde OpenLayers y en las transacciones WFS-T.
-- =====================================================================

-- Tablas con acentos o ñ
ALTER TABLE IF EXISTS "líneas_de_conducción_ene" RENAME TO lineas_de_conduccion_ene;
ALTER TABLE IF EXISTS "obra_de_comunicación"     RENAME TO obra_de_comunicacion;
ALTER TABLE IF EXISTS "marcas_y_señales"         RENAME TO marcas_y_senales;
ALTER TABLE IF EXISTS "señalizaciones"           RENAME TO senalizaciones;

-- Columnas con acentos, ñ o mayúsculas (recorre todas las tablas)
DO $$
DECLARE
  r record;
  nuevo text;
BEGIN
  FOR r IN
    SELECT table_name, column_name
    FROM information_schema.columns
    WHERE table_schema = 'public' AND column_name ~ '[^a-z0-9_]'
  LOOP
    nuevo := lower(translate(r.column_name, 'áéíóúñüÁÉÍÓÚÑÜ', 'aeiounuAEIOUNU'));
    nuevo := regexp_replace(nuevo, '[^a-z0-9_]', '_', 'g');

    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema = 'public' AND table_name = r.table_name AND column_name = nuevo) THEN
      RAISE NOTICE 'SALTEADA (ya existe %): %.%', nuevo, r.table_name, r.column_name;
    ELSE
      EXECUTE format('ALTER TABLE %I RENAME COLUMN %I TO %I', r.table_name, r.column_name, nuevo);
      RAISE NOTICE 'Renombrada: %.% -> %', r.table_name, r.column_name, nuevo;
    END IF;
  END LOOP;
END $$;

-- Control: debe devolver 0 filas
SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'public' AND column_name ~ '[^a-z0-9_]';
