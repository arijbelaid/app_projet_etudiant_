package com.example.etudiant_api.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Etudiant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String cin;

    private String nom;

    private LocalDate dateNaissance;

    @Column(unique = true, nullable = false)
    private String email;

    private int anneePremiereInscription;

    @ManyToOne
    @JoinColumn(name = "departement_id")
    private Departement departement;

    // Méthode age()
    public int age() {
        if (dateNaissance == null) return 0;
        return java.time.Period.between(dateNaissance, LocalDate.now()).getYears();
    }
}