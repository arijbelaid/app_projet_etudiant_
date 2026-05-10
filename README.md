#  Partie 1 – API REST Spring Boot 4 (Gestion des étudiants)

## 📌 Description

Cette API REST développée avec **Spring Boot 4** permet de gérer une liste d'étudiants.
Elle expose un endpoint permettant de récupérer les étudiants depuis une base de données **PostgreSQL** exécutée via Docker.

---

## 🛠️ Technologies utilisées

* Java 25
* Spring Boot 4
* Spring Web
* Spring Data JPA
* PostgreSQL (via Docker)
* Lombok (optionnel)
* Maven

---

## 🚀 Endpoint disponible

| Méthode | URL              | Description                     |
| ------- | ---------------- | ------------------------------- |
| GET     | `/api/etudiants` | Retourne la liste des étudiants |

---

## 🧾 Attributs d'un étudiant

* `id` : Long (auto-généré)
* `cin` : String
* `nom` : String
* `dateNaissance` : LocalDate

---

## 🐳 Lancer l'API avec Docker (PostgreSQL + Spring Boot)

Assurez-vous que Docker est installé et en cours d'exécution, puis lancez :

```bash id="sqqxrh"
docker compose up --build
```

👉 L'application sera accessible sur :
http://localhost:8080

---

## 📸 Screenshots (Partie 1)

### 1️⃣ Structure du projet

Cette capture montre l'organisation des dossiers du projet Spring Boot :

* `api-spring-boot/` : dossier principal de l'API
* `src/main/java/` : code source Java (controllers, entities, repositories)
* `src/main/resources/` : fichiers de configuration
* `pom.xml` : dépendances Maven

![Structure](screenshots_partie1/structure_projet_partie1.png)

---

### 2️⃣ Liste des étudiants (GET /api/etudiants)

Cette capture présente le résultat de l'appel API `GET /api/etudiants` avec la liste complète des étudiants.

Pour chaque étudiant :

* CIN
* Nom
* Date de naissance

![Liste des étudiants](screenshots_partie1/list_des_etudiants.png)

---

### 3️⃣ Exécution de l'API

Cette capture montre le bon fonctionnement de l'application :

* Console de lancement (logs Spring Boot)
* API accessible sur `http://localhost:8080`
* Chargement des données initiales

![Exécution](screenshots_partie1/execution.png)

---

## ✅ Résultat

L'API fonctionne correctement et permet de récupérer les données des étudiants depuis PostgreSQL via un endpoint REST simple.

# Partie 2 – Enrichissement de l'API Spring Boot

## Objectif

Cette partie enrichit le projet de la Partie 1 en ajoutant :

- Une méthode de calcul d'âge (`age()`)
- Des tests BDD avec Cucumber
- Une interface web statique (`index.html`)
- Une image Docker publiée sur Docker Hub
- Un déploiement Kubernetes (K3s)
- Une entité `Departement` avec relation `@ManyToOne`
- Une architecture en couches (DTO, Mapper, Service, Controller)
- Des opérations CRUD complètes
- Une gestion des erreurs HTTP standard
- Un cache Redis
- Un projet Jira Scrum

---
---

##  – Tests BDD avec Cucumber

Exécution des tests Cucumber validant la méthode `age()`.

![Tests Cucumber](screenshots_partie2/cucumber_tests.png)

---
##  – Page `index.html` avec Fetch JavaScript

Page statique consommant l'API et affichant les étudiants.

![Page index.html](screenshots_partie2/index_html.png)

---

##  – Construction et publication de l’image Docker sur Docker Hub

Construction de l’image avec le tag arijbelaid/etudiant-service:1.0, puis push vers le registre Docker Hub.
Les logs montrent le succès de l’opération (pushed/mounted)

![image docker](screenshots_partie2/pousher_image.png)

---

##  – Déploiement sur Kubernetes (K3s)

Vérification des pods et services sur le cluster K3s.

![Pods et services Kubernetes](screenshots_partie2/k8s_pods_and_services.png)

---
##  – Requête personnalisée

Recherche des étudiants par année d'inscription.

![Recherche par année 2022](screenshots_partie2/api_search_by_annee_2022.png)

---
##  – CRUD complet

### Création d'un département

![POST département](screenshots_partie2/add_departement.png)

### Création d'un étudiant

![GET étudiant après création](screenshots_partie2/creeation_etudiant.png)

![GET étudiant après création](screenshots_partie2/etudiant_cree.png)

### Modification d'un étudiant

![PUT étudiant](screenshots_partie2/modifier_etudiant.png)

![PUT étudiant](screenshots_partie2/etudiant_modifie.png)

### Suppression et modification departement

![DELETE étudiant](screenshots_partie2/modify_and_delete_departement.png)

---

##  – Gestion des erreurs

Erreur 404 retournée pour un étudiant inexistant.

![Erreur 404](screenshots_partie2/not_found.png)

---

##  – Tests Swagger de l’API 

Les captures ci‑dessous illustrent le bon fonctionnement de l’API REST documentée avec Swagger. Elles montrent la création réussie d’un département (201 Created), la création d’un étudiant avec relation ManyToOne, ainsi que le filtrage des étudiants par année d’inscription via le paramètre annee.

![test annee](screenshots_partie2/test_annee_swagger.png)

![add departement](screenshots_partie2/add_departement_swagger.png)

![add etudiant](screenshots_partie2/add_etudiant_swagger.png)

---

##  –Validation du cache Redis pour les endpoints étudiant et département

![radis](screenshots_partie2/radis_etudiant_departement.png)

---
##  – Execution des interfaces web et mobile

![interface mobile departement](screenshots_partie2/execution_crud_departement.png)

![interface mobile etudiant](screenshots_partie2/execution_crud_etudiant.png)

![interface web departement](screenshots_partie2/execution_crud_departement_web.png)

![interface web etudiant](screenshots_partie2/execution_crud_etudiant_web.png)


## – Organisation Jira Scrum

### Sprint 1 – API REST de base (Partie 1)

![Sprint 1 Jira](screenshots_partie2/jira_sprint1_partie1.png)

### Sprint 2 – Enrichissement (Partie 2)

![Sprint 2 Jira](screenshots_partie2/jira_sprint2_partie1.png)
![Sprint 2 Jira](screenshots_partie2/jira_sprint2_partie1.png)

---

## Conclusion

Toutes les fonctionnalités de la Partie 2 ont été implémentées et testées avec succès :

- ✅ API Spring Boot enrichie
- ✅ Tests BDD passants
- ✅ Interface web statique
- ✅ Image Docker publiée
- ✅ Déploiement Kubernetes
- ✅ CRUD complet
- ✅ Gestion des erreurs
- ✅ swagger
- ✅ radis
- ✅ Organisation Agile avec Jira

