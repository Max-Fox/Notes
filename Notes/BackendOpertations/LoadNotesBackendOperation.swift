import Foundation



class LoadNotesBackendOperation: AsyncOperation {
    
    var result: [Note]? = [Note(title: "31", content: "fda", priority: .usual, dateDead: nil)]
    
    override init() {
        super.init()
    }
    override func main() {
        print("Error LoadNotesBackendOperation")
        //let note = Note(title: "341", content: "fdarewr", priority: .usual, dateDead: nil)
        //result?.append(Note(title: "31", content: "fda", priority: .usual, dateDead: nil)) // Заглушкка, необходимо получить заметки из бэка
        result = nil //?.append(Note(title: "321", content: "fda", priority: .usual, dateDead: nil))
        
        finish()
    }
}
