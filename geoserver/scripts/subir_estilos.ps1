# Sube todos los .sld de la carpeta geoserver/estilos a GeoServer y los asigna como
# estilo por defecto de la capa que tiene el mismo nombre que el archivo.
# Uso: abrir PowerShell en esta carpeta y ejecutar:
#   powershell -ExecutionPolicy Bypass -File .\subir_estilos.ps1

$gs   = "http://localhost:8080/geoserver/rest"   # cambiar el puerto si usaste otro
$ws   = "sig250"
$user = "admin"
$pass = "TU_CLAVE_DE_GEOSERVER"

$token   = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${user}:${pass}"))
$headers = @{ Authorization = "Basic $token" }

# Busca los .sld en ..\estilos (estructura del repositorio) o, si no, en esta misma carpeta
$carpeta = Join-Path $PSScriptRoot "..\estilos"
if (-not (Test-Path $carpeta)) { $carpeta = $PSScriptRoot }

Get-ChildItem -Path $carpeta -Filter *.sld | ForEach-Object {
  $nombre = $_.BaseName
  try {
    # 1) Crear el estilo (si ya existe, se actualiza)
    try {
      Invoke-RestMethod -Method Post -Uri "$gs/workspaces/$ws/styles?name=$nombre" `
        -Headers $headers -ContentType "application/vnd.ogc.sld+xml" -InFile $_.FullName | Out-Null
    } catch {
      Invoke-RestMethod -Method Put -Uri "$gs/workspaces/$ws/styles/$nombre" `
        -Headers $headers -ContentType "application/vnd.ogc.sld+xml" -InFile $_.FullName | Out-Null
    }

    # 2) Asignarlo como estilo por defecto de la capa
    $body = @{ layer = @{ defaultStyle = @{ name = $nombre; workspace = $ws } } } | ConvertTo-Json -Depth 4
    Invoke-RestMethod -Method Put -Uri "$gs/layers/${ws}:$nombre" `
      -Headers $headers -ContentType "application/json" -Body $body | Out-Null

    Write-Host "OK     $nombre" -ForegroundColor Green
  } catch {
    Write-Host "ERROR  $nombre : $($_.Exception.Message)" -ForegroundColor Red
  }
}
