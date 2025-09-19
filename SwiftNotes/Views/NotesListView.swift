import SwiftUI

struct NotesListView: View {
    @EnvironmentObject private var viewModel: NotesViewModel
    @State private var showEditor: Bool = false
    @State private var draftNote: Note? = nil

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.displayNotes) { note in
                    Button {
                        draftNote = note
                        showEditor = true
                    } label: {
                        NoteRowView(note: note)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.delete(noteID: note.id)
                        } label: {
                            Label("Șterge", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            viewModel.togglePin(noteID: note.id)
                        } label: {
                            Label(note.isPinned ? "Anulează pin" : "Fixează", systemImage: note.isPinned ? "pin.slash" : "pin")
                        }
                        .tint(.yellow)
                    }
                }
            }
            .overlay {
                if viewModel.displayNotes.isEmpty {
                    ContentUnavailableView("Nicio notiță", systemImage: "note.text") {
                        Text("Adaugă una nouă cu butonul +")
                    }
                }
            }
            .navigationTitle("Notițe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sortare", selection: $viewModel.sortOrder) {
                            ForEach(NotesViewModel.SortOrder.allCases) { order in
                                Text(order.displayName).tag(order)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        draftNote = viewModel.createNewNote()
                        showEditor = true
                    } label: {
                        Label("Adaugă", systemImage: "plus.circle.fill")
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Caută notițe")
            .sheet(isPresented: $showEditor, onDismiss: { draftNote = nil }) {
                if let draftNote {
                    NoteEditorView(note: draftNote) { result in
                        switch result {
                        case .cancel:
                            break
                        case .save(let note):
                            if viewModel.displayNotes.contains(where: { $0.id == note.id }) {
                                viewModel.saveEdited(note: note)
                            } else {
                                viewModel.add(note: note)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct NoteRowView: View {
    let note: Note

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if note.isPinned {
                Image(systemName: "pin.fill")
                    .foregroundStyle(.yellow)
                    .padding(.top, 2)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(note.title.isEmpty ? "(Fără titlu)" : note.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(note.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(note.updatedAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    let vm = NotesViewModel(persistence: JSONNotesPersistence())
    return NotesListView()
        .environmentObject(vm)
}

