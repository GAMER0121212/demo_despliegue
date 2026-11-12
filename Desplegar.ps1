
param(
    [string]$RutaPHP = 'C:\xampp\php\php.exe'
)

# Rutas de los archivos
$archivoOrigen = Join-Path $PSScriptRoot 'origen\index.php'
$carpetaPruebas = Join-Path $PSScriptRoot 'pruebas'
$archivoDestino = Join-Path $carpetaPruebas 'index.php'

if (-not (Test-Path $RutaPHP)) {
    Write-Host "ERROR: No se encontro PHP en XAMPP." -ForegroundColor Red
    exit 1
}

# Verificar que el archivo origen exista
if (-not (Test-Path $archivoOrigen)) {
    Write-Host "ERROR: No existe origen\index.php." -ForegroundColor Red
    exit 1
}


Write-Host "Verificando sintaxis PHP..." -ForegroundColor Yellow

& $RutaPHP -l $archivoOrigen

if ($LASTEXITCODE -ne 0) {
    Write-Host "Hay un error de sintaxis. No se publico el cambio." -ForegroundColor Red
    exit 1
}


if (-not (Test-Path $carpetaPruebas)) {
    New-Item -ItemType Directory -Path $carpetaPruebas -Force | Out-Null
}


try {
    Copy-Item $archivoOrigen $archivoDestino -Force -ErrorAction Stop

    Write-Host "Version publicada en el ambiente de prueba." -ForegroundColor Green
}
catch {
    Write-Host "ERROR: No se pudo publicar el archivo: $_" -ForegroundColor Red
    exit 1
}


Write-Host "Iniciando servidor PHP..." -ForegroundColor Cyan
Write-Host "Abre http://localhost:8000 en tu navegador."

& $RutaPHP -S localhost:8000 -t $carpetaPruebas
