import SwiftUI

struct NoteEditorView: View {
    enum Result {
        case cancel
        case save(Note)
    }

    let note: Note
    let onComplete: (Result) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var body: String

    init(note: Note, onComplete: @escaping (Result) -> Void) {
        self.note = note
        self.onComplete = onComplete
        _title = State(initialValue: note.title)
        _body = State(initialValue: note.body)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Titlu")) {
                    TextField("Titlul notiței", text: $title)
                }
                Section(header: Text("Conținut")) {
                    TextEditor(text: $body)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle(note.title.isEmpty ? "Notiță" : "Editează notița")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anulează") {
                        onComplete(.cancel)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvează") {
                        var edited = note
                        edited.title = title
                        edited.body = body
                        onComplete(.save(edited))
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NoteEditorView(note: Note(title: "Exemplu", body: "Text")) { _ in }
}

