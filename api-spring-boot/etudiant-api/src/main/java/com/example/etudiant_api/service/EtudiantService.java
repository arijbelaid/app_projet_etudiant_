package com.example.etudiant_api.service;

import com.example.etudiant_api.dto.EtudiantDTO;
import com.example.etudiant_api.entity.Departement;
import com.example.etudiant_api.entity.Etudiant;
import com.example.etudiant_api.exception.ResourceNotFoundException;
import com.example.etudiant_api.mapper.EtudiantMapper;
import com.example.etudiant_api.repository.DepartementRepository;
import com.example.etudiant_api.repository.EtudiantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EtudiantService {

    private final EtudiantRepository etudiantRepository;
    private final DepartementRepository departementRepository;
    private final EtudiantMapper mapper;

    // Cache la liste complète des étudiants (clé fixe "all")
    @Cacheable(value = "etudiants", key = "'all'")
    @Transactional(readOnly = true)
    public List<EtudiantDTO> getAllEtudiants() {
        return etudiantRepository.findAll()
                .stream()
                .map(mapper::toDTO)
                .collect(Collectors.toList());
    }

    // Cache un étudiant par son ID
    @Cacheable(value = "etudiants", key = "#id")
    @Transactional(readOnly = true)
    public EtudiantDTO getEtudiantById(Long id) {
        Etudiant etudiant = etudiantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Étudiant non trouvé avec id : " + id));
        return mapper.toDTO(etudiant);
    }

    // À chaque écriture (création, maj, suppression), on vide tout le cache "etudiants"
    @CacheEvict(value = "etudiants", allEntries = true)
    @Transactional
    public EtudiantDTO createEtudiant(EtudiantDTO dto) {
        Departement departement = null;
        if (dto.getDepartementId() != null) {
            departement = departementRepository.findById(dto.getDepartementId())
                    .orElseThrow(() -> new ResourceNotFoundException("Département non trouvé avec id : " + dto.getDepartementId()));
        }
        Etudiant etudiant = mapper.toEntity(dto, departement);
        etudiant = etudiantRepository.save(etudiant);
        return mapper.toDTO(etudiant);
    }

    @CacheEvict(value = "etudiants", allEntries = true)
    @Transactional
    public EtudiantDTO updateEtudiant(Long id, EtudiantDTO dto) {
        Etudiant existing = etudiantRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Étudiant non trouvé avec id : " + id));

        existing.setCin(dto.getCin());
        existing.setNom(dto.getNom());
        existing.setDateNaissance(dto.getDateNaissance());
        existing.setEmail(dto.getEmail());
        existing.setAnneePremiereInscription(dto.getAnneePremiereInscription());

        if (dto.getDepartementId() != null) {
            Departement dept = departementRepository.findById(dto.getDepartementId())
                    .orElseThrow(() -> new ResourceNotFoundException("Département non trouvé avec id : " + dto.getDepartementId()));
            existing.setDepartement(dept);
        } else {
            existing.setDepartement(null);
        }

        Etudiant updated = etudiantRepository.save(existing);
        return mapper.toDTO(updated);
    }

    @CacheEvict(value = "etudiants", allEntries = true)
    @Transactional
    public void deleteEtudiant(Long id) {
        if (!etudiantRepository.existsById(id)) {
            throw new ResourceNotFoundException("Étudiant non trouvé avec id : " + id);
        }
        etudiantRepository.deleteById(id);
    }

    // Cache les résultats par année (clé = année)
    @Cacheable(value = "etudiantsByAnnee", key = "#annee")
    @Transactional(readOnly = true)
    public List<EtudiantDTO> getEtudiantsByAnnee(int annee) {
        return etudiantRepository.findByAnneePremiereInscription(annee)
                .stream()
                .map(mapper::toDTO)
                .collect(Collectors.toList());
    }
}