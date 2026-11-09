# Publica en GeoServer todas las tablas del almacen PostGIS que todavia
# no estan publicadas, usando la API REST.
# Uso: abrir PowerShell en esta carpeta y ejecutar:
#   powershell -ExecutionPolicy Bypass -File .\publicar_capas.ps1

$gs   = "http://localhost:8080/geoserver/rest"   # cambiar el puerto si corresponde
$ws   = "sig250"                                 # espacio de trabajo
$st   = "pg_sig250"                              # almacen PostGIS
$user = "admin"
$pass = "TU_CLAVE_DE_GEOSERVER"

$token   = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${user}:${pass}"))
$headers = @{ Authorization = "Basic $token" }

# Tablas del almacen que todavia no estan publicadas
$disp  = Invoke-RestMethod -Uri "$gs/workspaces/$ws/datastores/$st/featuretypes.json?list=available" -Headers $headers
$capas = @($disp.list.string)
Write-Host "Capas a publicar: $($capas.Count)"

foreach ($t in $capas) {
  $body = @{ featureType = @{ name = $t; nativeName = $t; srs = "EPSG:4326" } } | ConvertTo-Json -Depth 3
  try {
    Invoke-RestMethod -Method Post -Uri "$gs/workspaces/$ws/datastores/$st/featuretypes" `
      -Headers $headers -ContentType "application/json" -Body $body | Out-Null
    Write-Host "OK     $t" -ForegroundColor Green
  } catch {
    Write-Host "ERROR  $t : $($_.Exception.Message)" -ForegroundColor Red
  }
}
