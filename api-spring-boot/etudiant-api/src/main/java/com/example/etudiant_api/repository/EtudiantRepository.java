package com.example.etudiant_api.repository;

import com.example.etudiant_api.entity.Etudiant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface EtudiantRepository extends JpaRepository<Etudiant, Long> {
    List<Etudiant> findByAnneePremiereInscription(int annee);
}