import SwiftUI

@main
struct SwiftNotesApp: App {
    @StateObject private var viewModel = NotesViewModel(persistence: JSONNotesPersistence())

    var body: some Scene {
        WindowGroup {
            NotesListView()
                .environmentObject(viewModel)
        }
    }
}

