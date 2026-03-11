# Script de inicialización - Challenge Foro Hub (PowerShell)
# Para ejecutar: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Luego: .\init.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Challenge Foro Hub - Inicialización" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Maven está instalado
Write-Host "Verificando Maven..." -ForegroundColor Green
$mvnPath = Get-Command mvn -ErrorAction SilentlyContinue
if (-not $mvnPath) {
    Write-Host "Maven no está instalado. Instálalo primero." -ForegroundColor Red
    exit 1
}
Write-Host "Maven encontrado: $($mvnPath.Source)" -ForegroundColor Green

# Verificar si Java está instalado
Write-Host "Verificando Java..." -ForegroundColor Green
$javaPath = Get-Command java -ErrorAction SilentlyContinue
if (-not $javaPath) {
    Write-Host "Java no está instalado. Instálalo primero." -ForegroundColor Red
    exit 1
}
$javaVersion = java -version 2>&1 | Select-Object -First 1
Write-Host "Java encontrado: $javaVersion" -ForegroundColor Green

# Crear base de datos
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Creando Base de Datos..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Por favor, ingresa tu usuario de MySQL:" -ForegroundColor Yellow

$dbUser = Read-Host "Usuario de MySQL (por defecto: root)"
if ([string]::IsNullOrEmpty($dbUser)) {
    $dbUser = "root"
}

$dbPassword = Read-Host "Contraseña de MySQL" -AsSecureString
$dbPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicodePtr($dbPassword))

# Crear base de datos usando mysql CLI
try {
    $mysqlCmd = @"
mysql -u $dbUser -p$dbPasswordPlain -e "CREATE DATABASE IF NOT EXISTS forohub;" 2>nul
"@
    Invoke-Expression $mysqlCmd
    Write-Host "✓ Base de datos creada o ya existe" -ForegroundColor Green
} catch {
    Write-Host "✗ Error al crear la base de datos" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Compilando Proyecto..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Limpiar e instalar
mvn clean install

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Proyecto compilado exitosamente" -ForegroundColor Green
} else {
    Write-Host "✗ Error al compilar el proyecto" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "¡Listo! Próximos pasos:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Edita src/main/resources/application.properties" -ForegroundColor Yellow
Write-Host "   - Actualiza spring.datasource.username" -ForegroundColor Gray
Write-Host "   - Actualiza spring.datasource.password" -ForegroundColor Gray
Write-Host "   - Actualiza jwt.secret" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Ejecuta la aplicación:" -ForegroundColor Yellow
Write-Host "   mvn spring-boot:run" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Prueba con PowerShell:" -ForegroundColor Yellow
Write-Host '   $token = (Invoke-WebRequest -Uri "http://localhost:8080/login" -Method POST -Headers @{"Content-Type"="application/json"} -Body ''{"correoElectronico":"juan@example.com","contrasena":"123456"}'' | ConvertFrom-Json).token' -ForegroundColor Gray
Write-Host ""
Write-Host "4. Importa Foro_Hub_API.postman_collection.json en Postman" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Felicidades! Proyecto listo para desarrollo" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
