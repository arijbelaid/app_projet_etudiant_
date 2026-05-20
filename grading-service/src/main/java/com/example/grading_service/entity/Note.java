package com.example.grading_service.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Note {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long studentId;  // Référence vers l'étudiant (pas de FK JPA)

    @Column(nullable = false)
    private String matiere;

    @Column(nullable = false)
    private Double valeur;
}