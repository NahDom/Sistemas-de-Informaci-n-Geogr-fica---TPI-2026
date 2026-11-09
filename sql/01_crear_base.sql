-- =====================================================================
-- 01 · Base de datos espacial
-- 1) Crear la base "sig250_tpi" desde pgAdmin (Databases > Create > Database)
-- 2) Conectado a sig250_tpi, ejecutar:
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS postgis;

-- Verificación de la instalación
SELECT postgis_full_version();
