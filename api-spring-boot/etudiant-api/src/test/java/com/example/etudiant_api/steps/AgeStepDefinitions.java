package com.example.etudiant_api.steps;


import com.example.etudiant_api.entity.Etudiant;

import com.example.etudiant_api.entity.Etudiant;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class AgeStepDefinitions {

    private Etudiant etudiant;
    private int ageCalcule;

    @Given("un étudiant avec la date de naissance {string}")
    public void unEtudiantAvecDateNaissance(String dateNaissanceStr) {
        LocalDate dateNaissance = LocalDate.parse(dateNaissanceStr);
        etudiant = new Etudiant();
        etudiant.setDateNaissance(dateNaissance);
    }

    @When("on calcule son âge")
    public void onCalculeSonAge() {
        ageCalcule = etudiant.age();
    }

    @Then("l'âge retourné doit être {int}")
    public void lAgeRetourneDoitEtre(int ageAttendu) {
        assertEquals(ageAttendu, ageCalcule);
    }
}