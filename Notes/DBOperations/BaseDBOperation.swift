import UIKit

enum BaseDBOperationResult {
    case success
    case failure(NetworkError)
}

class BaseDBOperation: AsyncOperation {
    let notebook: FileNotebook
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Хранение общей записной книги
    var result: BaseDBOperationResult?
    
    override init() {
        self.notebook = appDelegate.fileNotebook
        super.init()
    }
    override func main() {
        print("Error BaseDBOperation")
        result = .failure(.unreachable)
        finish()
    }
}
