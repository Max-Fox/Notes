import Foundation

class RemoveNotesOperation: AsyncOperation {
    
    private let notebook: FileNotebook
    private let removeToDb: RemoveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    private var backendQueue = OperationQueue()
    private var dbQueue = OperationQueue()
    
    init(notebook: FileNotebook, id: String) {
        self.notebook = notebook

        
        removeToDb = RemoveNoteDBOperation(with: id)
        
        super.init()
        
        removeToDb.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
            self.saveToBackend = saveToBackend
            self.addDependency(saveToBackend)
            self.backendQueue.addOperation(saveToBackend)
        }
        addDependency(removeToDb)
        dbQueue.addOperation(removeToDb)
    }
    
    override func main() {
        //        switch saveToBackend!.result! {
        //        case .success:
        //            result = true
        //        case .failure:
        //            result = false
        //        }
        print("Заметка удалена")
        finish()
    }
}
