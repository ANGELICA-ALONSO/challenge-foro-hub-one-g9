@echo off
REM Script de inicialización rápida - Challenge Foro Hub para Windows
REM Este script creará la base de datos y compilará el proyecto

setlocal enabledelayedexpansion

echo.
echo ========================================
echo  Challenge Foro Hub - Inicialización
echo ========================================
echo.

REM Verificar si Maven está instalado
echo Verificando Maven...
where mvn >nul 2>nul
if errorlevel 1 (
    echo Error: Maven no está instalado o no está en PATH
    echo Por favor, instala Maven desde: https://maven.apache.org/download.cgi
    pause
    exit /b 1
)
echo Maven encontrado

REM Verificar si Java está instalado
echo Verificando Java...
where java >nul 2>nul
if errorlevel 1 (
    echo Error: Java no está instalado
    echo Por favor, instala Java desde: https://www.oracle.com/java/technologies/downloads/
    pause
    exit /b 1
)
for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| find /i "version"') do set JAVA_VER=%%i
echo Java %JAVA_VER% encontrado

echo.
echo ========================================
echo  Creando Base de Datos
echo ========================================
echo.

set /p DB_USER="Usuario de MySQL (por defecto: root): "
if "%DB_USER%"=="" set DB_USER=root

set /p DB_PASS="Contraseña de MySQL: "

echo.
echo Creando base de datos forohub...

mysql -u %DB_USER% -p%DB_PASS% -e "CREATE DATABASE IF NOT EXISTS forohub;" >nul 2>&1

if errorlevel 1 (
    echo Error al crear la base de datos
    echo Verifica que MySQL está corriendo y las credenciales son correctas
    pause
    exit /b 1
) else (
    echo Base de datos creada exitosamente
)

echo.
echo ========================================
echo  Compilando Proyecto
echo ========================================
echo.

call mvn clean install

if errorlevel 1 (
    echo Error al compilar el proyecto
    pause
    exit /b 1
)

echo.
echo ========================================
echo  Listo! Próximos pasos:
echo ========================================
echo.
echo 1. Edita src\main\resources\application.properties
echo    - Actualiza spring.datasource.username
echo    - Actualiza spring.datasource.password
echo    - Actualiza jwt.secret
echo.
echo 2. Ejecuta la aplicación:
echo    mvn spring-boot:run
echo.
echo 3. Prueba con PowerShell:
echo    $token = (Invoke-WebRequest -Uri "http://localhost:8080/login" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"correoElectronico":"juan@example.com","contrasena":"123456"}' ^| ConvertFrom-Json).token
echo.
echo 4. Importa Foro_Hub_API.postman_collection.json en Postman
echo.
echo ========================================
echo  Felicidades! Proyecto listo para desarrollo
echo ========================================

pause
