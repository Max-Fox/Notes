import Foundation

class LoadNotesOperation: AsyncOperation {
    private let notebook: FileNotebook
    private let loadToDb: LoadNotesDBOperation
    private var loadToBackend: LoadNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(notebook: FileNotebook, opQueue: OperationQueue) {
        
        self.notebook = notebook
        
        loadToDb = LoadNotesDBOperation()
        opQueue.addOperation(loadToDb)
        loadToDb.waitUntilFinished()
        
        super.init()
        
        
        let loadToBackendOperation = LoadNotesBackendOperation()
        self.loadToBackend = loadToBackendOperation
        loadToDb.addDependency(loadToBackendOperation)
        opQueue.addOperation(loadToBackendOperation)
        loadToBackendOperation.waitUntilFinished()
        //opQueue.addOperation(loadToDb)
        
//        loadToDb.completionBlock = {
//            let loadToBackend = LoadNotesBackendOperation()
//            self.loadToBackend = loadToBackend
//            self.addDependency(loadToBackend)
//            backendQueue.addOperation(loadToBackend)
//        }
    }
    
    override func main() {
        //        switch loadToBackend!.result! {
        //        case .success:
        //            result = true
        //        case .failure:
        //            result = false
        //        }
        
        print("LoadNotesFromBackendOperation")
        
        let notesDB = loadToDb.result
        let notesBackend = loadToBackend?.result
        
        guard notesBackend != nil else {
            notebook.loadFromNotes(notes: notesDB!)
            finish()
            return
        }
        
        for (index, note) in (notesDB!.enumerated())  {
            if note.uid != notesBackend![index].uid {
                //Если данныые не совпадают
                //notesDB = notesBackend
                notebook.loadFromNotes(notes: notesBackend!)
                finish()
                return
            }
        }
        
        
    }
}
