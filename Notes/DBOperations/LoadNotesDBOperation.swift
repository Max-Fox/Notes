import UIKit



class LoadNotesDBOperation: AsyncOperation {
    var notebook: FileNotebook
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Хранение общей записной книги
    var result: [Note]?
    
    override init() {
        self.notebook = appDelegate.fileNotebook
        super.init()
    }
    override func main() {
        
        notebook.loadFromFile()
        
        result = notebook.notes
        
        finish()
    }
}
