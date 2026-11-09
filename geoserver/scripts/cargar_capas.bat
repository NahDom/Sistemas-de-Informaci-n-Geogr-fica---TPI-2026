@echo off
REM Carga todos los shapefiles de la carpeta actual en PostGIS con ogr2ogr.
REM Ejecutar desde la OSGeo4W Shell (incluida con QGIS), dentro de la carpeta de las capas SIG 250.
REM -lco PRECISION=NO evita el error "desbordamiento de campo numeric" de algunas capas del IGN.

set PGCONN=host=localhost port=5432 dbname=sig250_tpi user=postgres password=TU_CLAVE

for %%f in (*.shp) do (
  echo Cargando %%f ...
  ogr2ogr -f PostgreSQL PG:"%PGCONN%" "%%f" ^
    -lco GEOMETRY_NAME=geom -lco FID=id -lco SPATIAL_INDEX=GIST -lco PRECISION=NO ^
    -nlt PROMOTE_TO_MULTI -t_srs EPSG:4326 -overwrite
)
echo Listo.
