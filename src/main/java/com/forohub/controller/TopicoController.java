package com.forohub.controller;

import com.forohub.domain.topico.*;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;

@RestController
@RequestMapping("/topicos")
public class TopicoController {

    @Autowired
    private TopicoService topicoService;

    @PostMapping
    public ResponseEntity<DatosListadoTopico> crearTopico(
            @RequestBody @Valid DatosRegistroTopico datos,
            UriComponentsBuilder uriBuilder
    ) {
        try {
            var topico = topicoService.crearTopico(datos);
            URI uri = uriBuilder.path("/topicos/{id}").buildAndExpand(topico.id()).toUri();
            return ResponseEntity.created(uri).body(topico);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @GetMapping
    public ResponseEntity<Page<DatosListadoTopico>> listarTopicos(
            @PageableDefault(size = 10, sort = "fechaCreacion", direction = org.springframework.data.domain.Sort.Direction.ASC)
            Pageable pageable
    ) {
        Page<DatosListadoTopico> topicos = topicoService.listarTopicos(pageable);
        return ResponseEntity.ok(topicos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<DatosDetalleTopico> obtenerTopico(@PathVariable Long id) {
        try {
            var topico = topicoService.obtenerTopicoDetalle(id);
            return ResponseEntity.ok(topico);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<DatosDetalleTopico> actualizarTopico(
            @PathVariable Long id,
            @RequestBody @Valid DatosActualizacionTopico datos
    ) {
        try {
            var topico = topicoService.actualizarTopico(id, datos);
            return ResponseEntity.ok(topico);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminarTopico(@PathVariable Long id) {
        try {
            topicoService.eliminarTopico(id);
            return ResponseEntity.noContent().build();
        } catch (EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/buscar/curso")
    public ResponseEntity<Page<DatosListadoTopico>> listarTopicosPorCurso(
            @RequestParam String nombreCurso,
            @PageableDefault(size = 10, sort = "fechaCreacion", direction = org.springframework.data.domain.Sort.Direction.ASC)
            Pageable pageable
    ) {
        Page<DatosListadoTopico> topicos = topicoService.listarTopicosPorCurso(nombreCurso, pageable);
        return ResponseEntity.ok(topicos);
    }

    @GetMapping("/buscar/curso-year")
    public ResponseEntity<Page<DatosListadoTopico>> listarTopicosPorCursoYYear(
            @RequestParam String nombreCurso,
            @RequestParam int year,
            @PageableDefault(size = 10, sort = "fechaCreacion", direction = org.springframework.data.domain.Sort.Direction.ASC)
            Pageable pageable
    ) {
        Page<DatosListadoTopico> topicos = topicoService.listarTopicosPorCursoYYear(nombreCurso, year, pageable);
        return ResponseEntity.ok(topicos);
    }
}
