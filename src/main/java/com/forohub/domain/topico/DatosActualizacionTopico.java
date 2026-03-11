package com.forohub.domain.topico;

import jakarta.validation.constraints.NotBlank;

public record DatosActualizacionTopico(
        @NotBlank(message = "El título es obligatorio")
        String titulo,
        @NotBlank(message = "El mensaje es obligatorio")
        String mensaje,
        Long cursoId
) {}
