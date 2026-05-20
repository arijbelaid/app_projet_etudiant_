package com.example.grading_service.mapper;

import com.example.grading_service.dto.NoteDTO;
import com.example.grading_service.entity.Note;
import org.springframework.stereotype.Component;

@Component
public class NoteMapper {
    public NoteDTO toDTO(Note note) {
        if (note == null) return null;
        return new NoteDTO(note.getId(), note.getStudentId(), note.getMatiere(), note.getValeur());
    }

    public Note toEntity(NoteDTO dto) {
        if (dto == null) return null;
        return new Note(null, dto.getStudentId(), dto.getMatiere(), dto.getValeur());
    }
}