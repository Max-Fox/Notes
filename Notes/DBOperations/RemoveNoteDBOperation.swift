import UIKit

enum RemoveNoteDBOperationResult {
    case success
    case failure
}

class RemoveNoteDBOperation: AsyncOperation {
    var notebook: FileNotebook
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Хранение общей записной книги
    var result: RemoveNoteDBOperationResult?
    var uidForRemove: String
    
    init(with id: String) {
        self.notebook = appDelegate.fileNotebook
        self.uidForRemove = id
        super.init()
    }
    override func main() {
        
        notebook.remove(with: uidForRemove)
        result = .success
        print("Заметка удалена RemoveNoteDBOperation")
        
        finish()
    }
}
