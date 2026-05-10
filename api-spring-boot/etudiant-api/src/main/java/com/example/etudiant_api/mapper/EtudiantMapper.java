package com.example.etudiant_api.mapper;

import com.example.etudiant_api.dto.EtudiantDTO;
import com.example.etudiant_api.entity.Departement;
import com.example.etudiant_api.entity.Etudiant;
import org.springframework.stereotype.Component;

@Component
public class EtudiantMapper {

    public EtudiantDTO toDTO(Etudiant etudiant) {
        if (etudiant == null) return null;
        return EtudiantDTO.builder()
                .id(etudiant.getId())
                .cin(etudiant.getCin())
                .nom(etudiant.getNom())
                .dateNaissance(etudiant.getDateNaissance())
                .email(etudiant.getEmail())
                .anneePremiereInscription(etudiant.getAnneePremiereInscription())
                .departementId(etudiant.getDepartement() != null ? etudiant.getDepartement().getId() : null)
                .departementNom(etudiant.getDepartement() != null ? etudiant.getDepartement().getNom() : null)
                .build();
    }

    public Etudiant toEntity(EtudiantDTO dto, Departement departement) {
        if (dto == null) return null;
        return new Etudiant(
                dto.getId(),
                dto.getCin(),
                dto.getNom(),
                dto.getDateNaissance(),
                dto.getEmail(),
                dto.getAnneePremiereInscription(),
                departement
        );
    }
}