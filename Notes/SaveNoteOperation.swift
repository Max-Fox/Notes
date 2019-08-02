import Foundation

class SaveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    private let indexPath: Int
    
    private(set) var result: Bool? = false
    
    init(note: Note, index: Int,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        self.indexPath = index
        
        saveToDb = SaveNoteDBOperation(note: note, index: indexPath)
        
        super.init()
        
        saveToDb.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
            self.saveToBackend = saveToBackend
            self.addDependency(saveToBackend)
            backendQueue.addOperation(saveToBackend)
        }
        addDependency(saveToDb)
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {
//        switch saveToBackend!.result! {
//        case .success:
//            result = true
//        case .failure:
//            result = false
//        }
        finish()
    }
}
