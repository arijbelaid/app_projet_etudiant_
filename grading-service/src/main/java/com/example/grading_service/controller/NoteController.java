package com.example.grading_service.controller;

import com.example.grading_service.dto.NoteDTO;
import com.example.grading_service.service.NoteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import java.net.URI;
import java.util.List;


@RestController
@RequestMapping("/api/notes")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
@Tag(name = "Gestion des notes", description = "Endpoints pour gérer les notes des étudiants")
public class NoteController {

    private final NoteService service;

    @Operation(summary = "Récupérer toutes les notes")
    @GetMapping
    public List<NoteDTO> getAllNotes() {
        return service.getAllNotes();
    }

    @Operation(summary = "Récupérer les notes d’un étudiant")
    @GetMapping("/etudiant/{studentId}")
    public List<NoteDTO> getNotesByStudentId(@PathVariable Long studentId) {
        return service.getNotesByStudentId(studentId);
    }

    @Operation(summary = "Récupérer une note par son ID")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Note trouvée"),
            @ApiResponse(responseCode = "404", description = "Note non trouvée")
    })
    @GetMapping("/{id}")
    public ResponseEntity<NoteDTO> getNoteById(@PathVariable Long id) {
        return ResponseEntity.ok(service.getNoteById(id));
    }

    @Operation(summary = "Créer une nouvelle note")
    @ApiResponse(responseCode = "201", description = "Note créée")
    @PostMapping
    public ResponseEntity<NoteDTO> createNote(@Valid @RequestBody NoteDTO dto) {
        NoteDTO created = service.createNote(dto);
        URI location = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(created.getId())
                .toUri();
        return ResponseEntity.created(location).body(created);
    }

    @Operation(summary = "Modifier une note existante")
    @PutMapping("/{id}")
    public ResponseEntity<NoteDTO> updateNote(@PathVariable Long id, @Valid @RequestBody NoteDTO dto) {
        return ResponseEntity.ok(service.updateNote(id, dto));
    }

    @Operation(summary = "Supprimer une note")
    @ApiResponse(responseCode = "204", description = "Note supprimée")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNote(@PathVariable Long id) {
        service.deleteNote(id);
        return ResponseEntity.noContent().build();
    }
}