import Foundation

class BaseBackendOperation: AsyncOperation {
    
    private(set) var resultOperation: Bool? = false

    override init() {
        super.init()
    }
    
    override func main() {
        
        print("Server is not enable")
        resultOperation = false
        
        finish()
    }
    
}
