import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    private let note: Note
    private let index: Int
    
    init(note: Note, index: Int) {
        self.note = note
        self.index = index
        super.init()
    }
    
    override func main() {
        notebook.updateNote(note: note, indexPath: index)
        print("Сохранили локально")
        finish()
    }
}
