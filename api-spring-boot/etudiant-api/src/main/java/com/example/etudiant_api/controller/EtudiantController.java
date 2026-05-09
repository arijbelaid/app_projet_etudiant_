package com.example.etudiant_api.controller;


import com.example.etudiant_api.entity.Etudiant;
import com.example.etudiant_api.repository.EtudiantRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/etudiants")
@CrossOrigin(origins = "*") // pour autoriser l'app mobile (à restreindre en prod)
public class EtudiantController {

    private final EtudiantRepository repository;

    public EtudiantController(EtudiantRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Etudiant> getAllEtudiants() {
        return repository.findAll();
    }
}