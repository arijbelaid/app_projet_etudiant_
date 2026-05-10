package com.example.etudiant_api.mapper;

import com.example.etudiant_api.dto.DepartementDTO;
import com.example.etudiant_api.entity.Departement;
import org.springframework.stereotype.Component;

@Component
public class DepartementMapper {
    public DepartementDTO toDTO(Departement departement) {
        if (departement == null) return null;
        return new DepartementDTO(departement.getId(), departement.getNom());
    }

    public Departement toEntity(DepartementDTO dto) {
        if (dto == null) return null;
        return new Departement(dto.getNom());
    }
}