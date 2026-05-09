package com.example.etudiant_api.config;


import com.example.etudiant_api.entity.Etudiant;
import com.example.etudiant_api.repository.EtudiantRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;

@Component
public class DataInitializer {

    private final EtudiantRepository repository;

    public DataInitializer(EtudiantRepository repository) {
        this.repository = repository;
    }

    @PostConstruct
    public void init() {
        if (repository.count() == 0) {
            List<Etudiant> etudiants = List.of(
                    new Etudiant(null, "09127897", "Arij Belaid", LocalDate.of(2003, 5, 12)),
                    new Etudiant(null, "09897654", "Mariem Hammami", LocalDate.of(1999, 8, 23)),
                    new Etudiant(null, "12673890", "ichrak ben abdallah", LocalDate.of(2001, 2, 17)),
                    new Etudiant(null, "08907256", "maram youssef", LocalDate.of(2000, 11, 5)),
                    new Etudiant(null, "18675643", "molk selmfi", LocalDate.of(1998, 7, 30))
            );
            repository.saveAll(etudiants);
            System.out.println("5 étudiants insérés via @PostConstruct.");
        }
    }
}