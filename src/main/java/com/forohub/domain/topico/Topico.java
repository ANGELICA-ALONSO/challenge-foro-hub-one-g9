package com.forohub.domain.topico;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import com.forohub.domain.usuario.Usuario;
import com.forohub.domain.curso.Curso;

import java.time.LocalDateTime;

@Table(name = "topico")
@Entity(name = "Topico")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Topico {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String titulo;
    private String mensaje;
    @Column(name = "fecha_creacion")
    private LocalDateTime fechaCreacion;
    @Enumerated(EnumType.STRING)
    private StatusTopico status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "autor_id")
    private Usuario autor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "curso_id")
    private Curso curso;

    @PrePersist
    protected void onCreate() {
        fechaCreacion = LocalDateTime.now();
        status = StatusTopico.ABIERTO;
    }

    public void actualizar(String titulo, String mensaje, Curso curso) {
        if (titulo != null && !titulo.isBlank()) {
            this.titulo = titulo;
        }
        if (mensaje != null && !mensaje.isBlank()) {
            this.mensaje = mensaje;
        }
        if (curso != null) {
            this.curso = curso;
        }
    }
}
