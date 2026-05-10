package com.example.etudiant_api.service;

import com.example.etudiant_api.dto.DepartementDTO;
import com.example.etudiant_api.entity.Departement;
import com.example.etudiant_api.mapper.DepartementMapper;
import com.example.etudiant_api.repository.DepartementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DepartementService {

    private final DepartementRepository repository;
    private final DepartementMapper mapper;

    // Cache la liste complète des départements (clé fixe "all")
    @Cacheable(value = "departements", key = "'all'")
    @Transactional(readOnly = true)
    public List<DepartementDTO> getAll() {
        return repository.findAll().stream()
                .map(mapper::toDTO)
                .collect(Collectors.toList());
    }

    // Cache un département par son ID
    @Cacheable(value = "departements", key = "#id")
    @Transactional(readOnly = true)
    public DepartementDTO getById(Long id) {
        Departement dept = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Département introuvable"));
        return mapper.toDTO(dept);
    }

    // À chaque écriture (création, mise à jour, suppression) on vide tout le cache "departements"
    @CacheEvict(value = "departements", allEntries = true)
    @Transactional
    public DepartementDTO create(DepartementDTO dto) {
        Departement dept = mapper.toEntity(dto);
        dept = repository.save(dept);
        return mapper.toDTO(dept);
    }

    @CacheEvict(value = "departements", allEntries = true)
    @Transactional
    public DepartementDTO update(Long id, DepartementDTO dto) {
        Departement existing = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Département introuvable"));
        existing.setNom(dto.getNom());
        return mapper.toDTO(repository.save(existing));
    }

    @CacheEvict(value = "departements", allEntries = true)
    @Transactional
    public void delete(Long id) {
        if (!repository.existsById(id))
            throw new RuntimeException("Département introuvable");
        repository.deleteById(id);
    }
}