-- V1__Create_Usuario_Table.sql
CREATE TABLE IF NOT EXISTS usuario (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS perfil (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS usuario_perfil (
    usuario_id BIGINT NOT NULL,
    perfil_id BIGINT NOT NULL,
    PRIMARY KEY (usuario_id, perfil_id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (perfil_id) REFERENCES perfil(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS curso (
    id BIGINT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    categoria VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS topico (
    id BIGINT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    mensaje LONGTEXT NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'ABIERTO',
    autor_id BIGINT NOT NULL,
    curso_id BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_titulo_mensaje (titulo, mensaje(100)),
    FOREIGN KEY (autor_id) REFERENCES usuario(id),
    FOREIGN KEY (curso_id) REFERENCES curso(id)
);

CREATE TABLE IF NOT EXISTS respuesta (
    id BIGINT NOT NULL AUTO_INCREMENT,
    mensaje LONGTEXT NOT NULL,
    topico_id BIGINT NOT NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    autor_id BIGINT NOT NULL,
    solucion BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id),
    FOREIGN KEY (topico_id) REFERENCES topico(id) ON DELETE CASCADE,
    FOREIGN KEY (autor_id) REFERENCES usuario(id)
);

-- Índices adicionales para mejorar consultas
CREATE INDEX idx_topico_curso ON topico(curso_id);
CREATE INDEX idx_topico_autor ON topico(autor_id);
CREATE INDEX idx_topico_fecha ON topico(fecha_creacion);
CREATE INDEX idx_respuesta_topico ON respuesta(topico_id);
