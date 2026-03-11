-- V2__Insert_Test_Data.sql
-- Insertar Perfiles
INSERT INTO perfil (nombre) VALUES ('ADMIN');
INSERT INTO perfil (nombre) VALUES ('USUARIO');

-- Insertar Cursos
INSERT INTO curso (nombre, categoria) VALUES ('Spring Boot', 'Backend');
INSERT INTO curso (nombre, categoria) VALUES ('Java Avanzado', 'Backend');
INSERT INTO curso (nombre, categoria) VALUES ('Spring Security', 'Backend');
INSERT INTO curso (nombre, categoria) VALUES ('HTML CSS', 'Frontend');

-- Insertar Usuarios de prueba
-- Contraseña: $2a$10$Y50UAvmSLmVfBYEDYc3H/.WCupWQoIQDQwVS34Q6QWXeklPfm2uDm (123456 encriptada con BCrypt)
INSERT INTO usuario (nombre, correo_electronico, contrasena) VALUES 
('Juan Pérez', 'juan@example.com', '$2a$10$Y50UAvmSLmVfBYEDYc3H/.WCupWQoIQDQwVS34Q6QWXeklPfm2uDm');

INSERT INTO usuario (nombre, correo_electronico, contrasena) VALUES 
('María García', 'maria@example.com', '$2a$10$Y50UAvmSLmVfBYEDYc3H/.WCupWQoIQDQwVS34Q6QWXeklPfm2uDm');

INSERT INTO usuario (nombre, correo_electronico, contrasena) VALUES 
('Carlos López', 'carlos@example.com', '$2a$10$Y50UAvmSLmVfBYEDYc3H/.WCupWQoIQDQwVS34Q6QWXeklPfm2uDm');

-- Asignar Perfiles a Usuarios
INSERT INTO usuario_perfil (usuario_id, perfil_id) VALUES (1, 1);  -- Juan es ADMIN
INSERT INTO usuario_perfil (usuario_id, perfil_id) VALUES (1, 2);  -- Juan también es USUARIO
INSERT INTO usuario_perfil (usuario_id, perfil_id) VALUES (2, 2);  -- María es USUARIO
INSERT INTO usuario_perfil (usuario_id, perfil_id) VALUES (3, 2);  -- Carlos es USUARIO

-- Insertar Tópicos de prueba
INSERT INTO topico (titulo, mensaje, status, autor_id, curso_id) VALUES 
('¿Cómo validar datos en Spring Boot?', 'Necesito validar los datos de entrada en mis endpoints', 'ABIERTO', 1, 1);

INSERT INTO topico (titulo, mensaje, status, autor_id, curso_id) VALUES 
('Spring Security - Autenticación JWT', 'Quiero implementar autenticación con JWT en mi aplicación', 'ABIERTO', 2, 3);

INSERT INTO topico (titulo, mensaje, status, autor_id, curso_id) VALUES 
('¿Qué es una anotación en Java?', 'Me gustaría entender mejor cómo funcionan las anotaciones', 'RESUELTO', 3, 2);

-- Insertar Respuestas de prueba
INSERT INTO respuesta (mensaje, topico_id, autor_id, solucion) VALUES 
('Puedes usar la anotación @Valid con @RequestBody', 1, 2, false);

INSERT INTO respuesta (mensaje, topico_id, autor_id, solucion) VALUES 
('Las anotaciones son metadatos que proporciona información sobre el código', 3, 1, true);
