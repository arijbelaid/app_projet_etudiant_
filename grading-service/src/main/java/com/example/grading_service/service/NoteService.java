package com.example.grading_service.service;
import com.example.grading_service.dto.NoteDTO;
import com.example.grading_service.entity.Note;
import com.example.grading_service.exception.ResourceNotFoundException;
import com.example.grading_service.mapper.NoteMapper;
import com.example.grading_service.repository.NoteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NoteService {

    private final NoteRepository noteRepository;
    private final NoteMapper mapper;

    @Transactional(readOnly = true)
    public List<NoteDTO> getAllNotes() {
        return noteRepository.findAll().stream()
                .map(mapper::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<NoteDTO> getNotesByStudentId(Long studentId) {
        return noteRepository.findByStudentId(studentId).stream()
                .map(mapper::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public NoteDTO getNoteById(Long id) {
        Note note = noteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Note non trouvée avec id : " + id));
        return mapper.toDTO(note);
    }

    @Transactional
    public NoteDTO createNote(NoteDTO dto) {
        // TODO: Appeler student-service pour vérifier que l'étudiant existe (Q5)
        Note note = mapper.toEntity(dto);
        note = noteRepository.save(note);
        return mapper.toDTO(note);
    }

    @Transactional
    public NoteDTO updateNote(Long id, NoteDTO dto) {
        Note existing = noteRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Note non trouvée avec id : " + id));
        existing.setStudentId(dto.getStudentId());
        existing.setMatiere(dto.getMatiere());
        existing.setValeur(dto.getValeur());
        return mapper.toDTO(noteRepository.save(existing));
    }

    @Transactional
    public void deleteNote(Long id) {
        if (!noteRepository.existsById(id)) {
            throw new ResourceNotFoundException("Note non trouvée avec id : " + id);
        }
        noteRepository.deleteById(id);
    }
}