import Foundation
import Combine

@MainActor
final class NotesViewModel: ObservableObject {
    @Published private(set) var notes: [Note] = []
    @Published var searchText: String = ""
    @Published var sortOrder: SortOrder = .byUpdatedAtDesc

    enum SortOrder: String, CaseIterable, Identifiable {
        case byUpdatedAtDesc
        case byTitleAsc
        var id: String { rawValue }
        var displayName: String {
            switch self {
            case .byUpdatedAtDesc: return "Recente"
            case .byTitleAsc: return "Titlu A→Z"
            }
        }
    }

    private let persistence: NotesPersistence

    init(persistence: NotesPersistence) {
        self.persistence = persistence
        Task { await load() }
    }

    var displayNotes: [Note] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let filtered: [Note]
        if trimmed.isEmpty {
            filtered = notes
        } else {
            let lower = trimmed.lowercased()
            filtered = notes.filter { note in
                note.title.lowercased().contains(lower) || note.body.lowercased().contains(lower)
            }
        }
        let sorted = filtered.sorted { a, b in
            if a.isPinned != b.isPinned { return a.isPinned && !b.isPinned }
            switch sortOrder {
            case .byUpdatedAtDesc:
                return a.updatedAt > b.updatedAt
            case .byTitleAsc:
                return a.title.localizedCaseInsensitiveCompare(b.title) == .orderedAscending
            }
        }
        return sorted
    }

    func loadSampleIfEmpty() {
        guard notes.isEmpty else { return }
        notes = [
            Note(title: "Lista de cumpărături", body: "Lapte, ouă, pâine, cafea"),
            Note(title: "Idee aplicație", body: "App de notițe cu SwiftUI și căutare"),
            Note(title: "Întâlnire luni", body: "Discutat roadmap Q4"),
        ]
    }

    func createNewNote() -> Note {
        let new = Note(title: "", body: "")
        return new
    }

    func add(note: Note) {
        var toInsert = note
        toInsert.createdAt = Date()
        toInsert.updatedAt = Date()
        notes.insert(toInsert, at: 0)
        persist()
    }

    func saveEdited(note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        var updated = note
        updated.updatedAt = Date()
        notes[index] = updated
        persist()
    }

    func delete(noteID: UUID) {
        notes.removeAll { $0.id == noteID }
        persist()
    }

    func togglePin(noteID: UUID) {
        guard let index = notes.firstIndex(where: { $0.id == noteID }) else { return }
        notes[index].isPinned.toggle()
        notes[index].updatedAt = Date()
        persist()
    }

    func load() async {
        do {
            let loaded = try await persistence.load()
            self.notes = loaded
            loadSampleIfEmpty()
        } catch {
            self.notes = []
            loadSampleIfEmpty()
        }
    }

    private func persist() {
        let current = notes
        Task {
            try? await persistence.save(current)
        }
    }
}

