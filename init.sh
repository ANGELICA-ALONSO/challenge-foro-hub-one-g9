#!/bin/bash
# Script de inicialización rápida - Challenge Foro Hub

echo "========================================"
echo "Challenge Foro Hub - Inicialización"
echo "========================================"
echo ""

# Verificar si Maven está instalado
echo "✓ Verificando Maven..."
if ! command -v mvn &> /dev/null; then
    echo "✗ Maven no está instalado. Instálalo primero."
    exit 1
fi
echo "✓ Maven encontrado"

# Verificar si Java está instalado
echo "✓ Verificando Java..."
if ! command -v java &> /dev/null; then
    echo "✗ Java no está instalado. Instálalo primero."
    exit 1
fi
JAVA_VERSION=$(java -version 2>&1 | head -1 | awk -F '"' '{print $2}')
echo "✓ Java $JAVA_VERSION encontrado"

# Crear base de datos
echo ""
echo "========================================"
echo "Créando Base de Datos..."
echo "========================================"
echo "Por favor, ingresa tu contraseña de MySQL cuando se solicite:"
echo ""

read -p "Usuario de MySQL (por defecto: root): " DB_USER
DB_USER=${DB_USER:-root}

mysql -u $DB_USER -p -e "CREATE DATABASE IF NOT EXISTS forohub;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✓ Base de datos creada o ya existe"
else
    echo "✗ Error al crear la base de datos"
    exit 1
fi

echo ""
echo "========================================"
echo "Compilando Proyecto..."
echo "========================================"

# Limpiar e instalar
mvn clean install

if [ $? -eq 0 ]; then
    echo "✓ Proyecto compilado exitosamente"
else
    echo "✗ Error al compilar el proyecto"
    exit 1
fi

echo ""
echo "========================================"
echo "¡Listo! Próximos pasos:"
echo "========================================"
echo ""
echo "1. Edita src/main/resources/application.properties"
echo "   - Actualiza spring.datasource.username"
echo "   - Actualiza spring.datasource.password"
echo "   - Actualiza jwt.secret"
echo ""
echo "2. Ejecuta la aplicación:"
echo "   mvn spring-boot:run"
echo ""
echo "3. Prueba con curl:"
echo "   curl -X POST http://localhost:8080/login \\"
echo "     -H \"Content-Type: application/json\" \\"
echo "     -d '{\"correoElectronico\":\"juan@example.com\",\"contrasena\":\"123456\"}'"
echo ""
echo "4. Importa Foro_Hub_API.postman_collection.json en Postman"
echo ""
echo "========================================"
echo "¡Felicidades! Proyecto listo para desarrollo"
echo "========================================"
