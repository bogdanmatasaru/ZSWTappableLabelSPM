# SwiftNotes

Aplicație simplă de notițe construită cu SwiftUI. Suportă creare, editare, ștergere, fixare (pin), căutare și sortare. Datele sunt salvate local în `notes.json` folosind `JSONEncoder`/`JSONDecoder` cu `ISO8601` pentru date.

## Cerințe
- Xcode 15+ (iOS 17 SDK)
- iOS 17+ (folosește `ContentUnavailableView` și `#Preview`)

## Structură
- `SwiftNotesApp.swift`: punctul de intrare al aplicației
- `Models/Note.swift`: modelul de date pentru o notiță
- `Persistence/NotesPersistence.swift`: protocol și implementare JSON locală
- `ViewModels/NotesViewModel.swift`: logică de business (CRUD, căutare, sortare, pin)
- `Views/NotesListView.swift`: listă cu căutare, sortare, swipe actions
- `Views/NoteEditorView.swift`: ecran pentru creare/editare notiță

## Instalare / Rulare
1. Deschide Xcode și creează un proiect nou: iOS → App (SwiftUI, Swift).
2. Denumește-l „SwiftNotes”. Apoi închide Xcode.
3. Copiază fișierele din acest folder `SwiftNotes` peste proiectul tău (sau deschide proiectul și trage folderul în navigatorul Xcode cu „Copy items if needed” bifat și „Add to targets” pe aplicație).
4. Asigură-te că toate fișierele au „Target Membership” setat pe aplicație.
5. Rulează pe simulator (de ex. iPhone 15) sau pe dispozitiv (⌘R).

## Folosire
- Adaugă o notiță nouă cu butonul „Adaugă” din bara de jos.
- Glisează la stânga pe o notiță pentru „Șterge”.
- Glisează la dreapta pentru a „Fixa/Anula pin”. Notițele fixate apar primele.
- Caută prin titlu sau conținut din bara de căutare.
- Schimbă ordinea din meniu (Recente vs Titlu A→Z).

## Observații
- Persistența folosește Documents directory. Pe simulator, fișierul `notes.json` se află în containerul aplicației.
- Sortarea implicită este „Recente” (după `updatedAt` descrescător). Notițele fixate sunt prioritizate.
- Persistența este thread-safe prin `actor` (`JSONNotesPersistence`).

## Personalizare
- Poți migra la Core Data sau CloudKit pentru sincronizare iCloud.
- Adaugă suport Markdown în editor (preview live) sau tag-uri/culoare pentru notițe.