import Foundation

protocol NotesPersistence {
    func load() async throws -> [Note]
    func save(_ notes: [Note]) async throws
}

actor JSONNotesPersistence: NotesPersistence {
    private let fileName = "notes.json"

    func load() async throws -> [Note] {
        let url = try storageURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            return []
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Note].self, from: data)
    }

    func save(_ notes: [Note]) async throws {
        let url = try storageURL()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(notes)
        try ensureDirectoryExists(for: url)
        try data.write(to: url, options: .atomic)
    }

    private func storageURL() throws -> URL {
        #if os(iOS)
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        #else
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        #endif
        guard let directory else { throw CocoaError(.fileNoSuchFile) }
        return directory.appendingPathComponent(fileName)
    }

    private func ensureDirectoryExists(for url: URL) throws {
        let dir = url.deletingLastPathComponent()
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(atPath: dir.path, isDirectory: &isDir) {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
    }
}

