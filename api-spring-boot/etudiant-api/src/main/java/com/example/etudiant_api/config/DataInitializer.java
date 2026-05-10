package com.example.etudiant_api.config;

import com.example.etudiant_api.entity.Departement;
import com.example.etudiant_api.entity.Etudiant;
import com.example.etudiant_api.repository.DepartementRepository;
import com.example.etudiant_api.repository.EtudiantRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;

@Component
public class DataInitializer {

    private final EtudiantRepository etudiantRepository;
    private final DepartementRepository departementRepository;

    public DataInitializer(EtudiantRepository etudiantRepository,
                           DepartementRepository departementRepository) {
        this.etudiantRepository = etudiantRepository;
        this.departementRepository = departementRepository;
    }

    @PostConstruct
    public void init() {
        // 1. Créer les départements s'ils sont absents (ou les récupérer)
        Departement info = departementRepository.findByNom("Informatique").orElse(null);
        Departement maths = departementRepository.findByNom("Mathématiques").orElse(null);
        Departement physique = departementRepository.findByNom("Physique").orElse(null);

        if (info == null) {
            info = new Departement("Informatique");
            departementRepository.save(info);
        }
        if (maths == null) {
            maths = new Departement("Mathématiques");
            departementRepository.save(maths);
        }
        if (physique == null) {
            physique = new Departement("Physique");
            departementRepository.save(physique);
        }

        // 2. Insérer les étudiants seulement s'il n'y en a aucun (optionnel)
        if (etudiantRepository.count() == 0) {
            List<Etudiant> etudiants = List.of(
                    new Etudiant(null, "09127897", "Arij Belaid", LocalDate.of(2003, 5, 12),
                            "arij.belaid@example.com", 2021, info),
                    new Etudiant(null, "09897654", "Mariem Hammami", LocalDate.of(1999, 8, 23),
                            "mariem.hammami@example.com", 2018, maths),
                    new Etudiant(null, "12673890", "ichrak ben abdallah", LocalDate.of(2001, 2, 17),
                            "ichrak.benabdallah@example.com", 2019, info),
                    new Etudiant(null, "08907256", "maram youssef", LocalDate.of(2000, 11, 5),
                            "maram.youssef@example.com", 2019, physique),
                    new Etudiant(null, "18675643", "molk selmfi", LocalDate.of(1998, 7, 30),
                            "molk.selmfi@example.com", 2017, maths)
            );
            etudiantRepository.saveAll(etudiants);
            System.out.println("5 étudiants insérés.");
        }
    }
}