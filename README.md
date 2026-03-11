# Challenge Foro Hub - API REST con Spring Boot

API REST completa para un foro, implementada con Spring Boot 3.x, Java 17+, MySQL y autenticación JWT.

##  Requisitos Previos

- Java 17 o superior
- Maven 4+
- MySQL 8+
- Git

##  Configuración Inicial

### 1. Clonar el repositorio
```bash
git clone <tu-repositorio>
cd challenge-foro-hub
```

### 2. Crear base de datos MySQL
```sql
CREATE DATABASE forohub;
USE forohub;
```

### 3. Configurar application.properties
Editar `src/main/resources/application.properties` con tus credenciales de MySQL:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/forohub
spring.datasource.username=tu_usuario
spring.datasource.password=tu_contraseña
```

### 4. Configurar JWT Secret
En `application.properties`, cambiar:
```properties
jwt.secret=tu-clave-secreta-super-segura-con-minimo-256-bits-de-seguridad-aqui
```

### 5. Instalar dependencias y ejecutar
```bash
mvn clean install
mvn spring-boot:run
```

La aplicación estará disponible en: `http://localhost:8080`

##  Estructura del Proyecto

```
src/main/java/com/forohub/
├── controller/                 # Controladores REST
│   ├── AutenticacionController
│   └── TopicoController
├── domain/                     # Lógica de negocio
│   ├── topico/
│   ├── usuario/
│   └── curso/
├── infra/
│   └── security/               # Configuración de seguridad y JWT
└── ChallengeForoHubApplication # Clase principal
```

##  Autenticación

### 1. Obtener Token JWT

**POST** `/login`
```json
{
  "correoElectronico": "usuario@example.com",
  "contrasena": "contraseña"
}
```

**Respuesta:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 2. Usar Token en Solicitudes

Agregar el header:
```
Authorization: Bearer <token>
```

##  Endpoints Disponibles

### Tópicos

#### Crear Tópico
**POST** `/topicos`
```json
{
  "titulo": "Duda sobre Spring Boot",
  "mensaje": "¿Cómo implementar validaciones?",
  "autorId": 1,
  "cursoId": 1
}
```

#### Listar Tópicos
**GET** `/topicos?page=0&size=10`

#### Obtener Tópico por ID
**GET** `/topicos/{id}`

#### Actualizar Tópico
**PUT** `/topicos/{id}`
```json
{
  "titulo": "Duda actualizada sobre Spring Boot",
  "mensaje": "¿Cómo implementar validaciones avanzadas?",
  "cursoId": 1
}
```

#### Eliminar Tópico
**DELETE** `/topicos/{id}`

#### Listar Tópicos por Curso
**GET** `/topicos/buscar/curso?nombreCurso=Spring&page=0&size=10`

#### Listar Tópicos por Curso y Año
**GET** `/topicos/buscar/curso-year?nombreCurso=Spring&year=2025&page=0&size=10`

##  Base de Datos

### Tablas Principales

- **usuario**: Datos de usuarios del sistema
- **perfil**: Roles y perfiles de usuarios
- **curso**: Cursos disponibles
- **topico**: Tópicos/preguntas del foro
- **respuesta**: Respuestas a los tópicos

Las migraciones se ejecutan automáticamente con Flyway.

##  Validaciones Implementadas

- ✓ Todos los campos obligatorios son validados
- ✓ No se permiten tópicos duplicados (mismo título y mensaje)
- ✓ ID obligatorio para consultas de detalle
- ✓ Verificación de usuario y curso existentes
- ✓ Validación de email en autenticación
- ✓ Validación de token JWT

##  Seguridad

- Autenticación con JWT (JSON Web Token)
- Contraseñas encriptadas con BCrypt
- Spring Security configurado
- Endpoints protegidos requieren token válido
- CSRF deshabilitado para API REST

##  Dependencias Principales

- Spring Boot 3.2.0
- Spring Security
- Spring Data JPA
- Hibernate
- Flyway Migration
- MySQL Connector
- JWT Auth0
- Lombok
- Validation

##  Build y Deployment

### Build JAR
```bash
mvn clean package
```

### Ejecutar JAR
```bash
java -jar target/challenge-foro-hub-1.0.0.jar
```

