package com.forohub.domain.topico;

import com.forohub.domain.curso.CursoRepository;
import com.forohub.domain.usuario.UsuarioRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TopicoService {

    @Autowired
    private TopicoRepository topicoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private CursoRepository cursoRepository;

    @Transactional
    public DatosListadoTopico crearTopico(DatosRegistroTopico datos) {
        // Validar que no exista un tópico duplicado
        if (topicoRepository.existsByTituloAndMensaje(datos.titulo(), datos.mensaje())) {
            throw new IllegalArgumentException("Ya existe un tópico con este título y mensaje");
        }

        // Obtener usuario y curso
        var usuario = usuarioRepository.findById(datos.autorId())
                .orElseThrow(() -> new EntityNotFoundException("Usuario no encontrado"));

        var curso = cursoRepository.findById(datos.cursoId())
                .orElseThrow(() -> new EntityNotFoundException("Curso no encontrado"));

        // Crear el tópico
        var topico = new Topico(
                null,
                datos.titulo(),
                datos.mensaje(),
                null,
                null,
                usuario,
                curso
        );

        var topicoGuardado = topicoRepository.save(topico);
        return new DatosListadoTopico(topicoGuardado);
    }

    @Transactional(readOnly = true)
    public Page<DatosListadoTopico> listarTopicos(Pageable pageable) {
        Pageable paginacion = PageRequest.of(
                pageable.getPageNumber(),
                pageable.getPageSize(),
                Sort.by("fechaCreacion").ascending()
        );
        return topicoRepository.findAll(paginacion)
                .map(DatosListadoTopico::new);
    }

    @Transactional(readOnly = true)
    public Page<DatosListadoTopico> listarTopicosPorCurso(String nombreCurso, Pageable pageable) {
        Pageable paginacion = PageRequest.of(
                pageable.getPageNumber(),
                pageable.getPageSize(),
                Sort.by("fechaCreacion").ascending()
        );
        return topicoRepository.findByCursoNombre(nombreCurso, paginacion)
                .map(DatosListadoTopico::new);
    }

    @Transactional(readOnly = true)
    public Page<DatosListadoTopico> listarTopicosPorCursoYYear(String nombreCurso, int year, Pageable pageable) {
        Pageable paginacion = PageRequest.of(
                pageable.getPageNumber(),
                pageable.getPageSize(),
                Sort.by("fechaCreacion").ascending()
        );
        return topicoRepository.findByCursoNombreAndFechaCreacionYear(nombreCurso, year, paginacion)
                .map(DatosListadoTopico::new);
    }

    @Transactional(readOnly = true)
    public DatosDetalleTopico obtenerTopicoDetalle(Long id) {
        var topico = topicoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Tópico no encontrado"));
        return new DatosDetalleTopico(topico);
    }

    @Transactional
    public DatosDetalleTopico actualizarTopico(Long id, DatosActualizacionTopico datos) {
        var topico = topicoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Tópico no encontrado"));

        // Validar que no exista otro tópico duplicado con el mismo título y mensaje
        if (topicoRepository.existsByTituloAndMensaje(datos.titulo(), datos.mensaje())) {
            throw new IllegalArgumentException("Ya existe un tópico con este título y mensaje");
        }

        var curso = datos.cursoId() != null ? 
                cursoRepository.findById(datos.cursoId())
                        .orElseThrow(() -> new EntityNotFoundException("Curso no encontrado"))
                : topico.getCurso();

        topico.actualizar(datos.titulo(), datos.mensaje(), curso);
        return new DatosDetalleTopico(topico);
    }

    @Transactional
    public void eliminarTopico(Long id) {
        if (!topicoRepository.existsById(id)) {
            throw new EntityNotFoundException("Tópico no encontrado");
        }
        topicoRepository.deleteById(id);
    }
}
