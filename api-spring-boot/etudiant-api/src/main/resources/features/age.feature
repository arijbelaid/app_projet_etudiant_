Feature: Calcul de l'âge d'un étudiant

  Scenario: Étudiant né il y a 23 ans (anniversaire aujourd'hui)
    Given un étudiant avec la date de naissance "2003-05-09"
    When on calcule son âge
    Then l'âge retourné doit être 23

  Scenario: Étudiant né il y a 22 ans (anniversaire aujourd'hui)
    Given un étudiant avec la date de naissance "2004-05-09"
    When on calcule son âge
    Then l'âge retourné doit être 22

  Scenario: Étudiant né aujourd'hui
    Given un étudiant avec la date de naissance "2026-05-09"
    When on calcule son âge
    Then l'âge retourné doit être 0