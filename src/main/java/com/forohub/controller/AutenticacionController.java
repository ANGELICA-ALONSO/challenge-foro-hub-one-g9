package com.forohub.controller;

import com.forohub.domain.usuario.DatosAutenticacionUsuario;
import com.forohub.domain.usuario.DatosTokenJWT;
import com.forohub.domain.usuario.Usuario;
import com.forohub.infra.security.TokenService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/login")
public class AutenticacionController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private TokenService tokenService;

    @PostMapping
    public ResponseEntity<DatosTokenJWT> autenticar(@RequestBody @Valid DatosAutenticacionUsuario datos) {
        var authenticationToken = new UsernamePasswordAuthenticationToken(
                datos.correoElectronico(),
                datos.contrasena()
        );

        try {
            Authentication authentication = authenticationManager.authenticate(authenticationToken);
            var usuario = (Usuario) authentication.getPrincipal();
            var tokenJWT = tokenService.generarToken(usuario);
            return ResponseEntity.ok(new DatosTokenJWT(tokenJWT));
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
