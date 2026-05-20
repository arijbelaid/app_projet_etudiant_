package com.example.grading_service.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NoteDTO {
    private Long id;

    @NotNull(message = "L'ID de l'étudiant est obligatoire")
    private Long studentId;

    @NotBlank(message = "La matière est obligatoire")
    private String matiere;

    @NotNull(message = "La note est obligatoire")
    @DecimalMin(value = "0.0", message = "La note doit être >= 0")
    @DecimalMax(value = "20.0", message = "La note doit être <= 20")
    private Double valeur;
}