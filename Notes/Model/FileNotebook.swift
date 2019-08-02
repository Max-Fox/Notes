import Foundation
import CocoaLumberjack

class FileNotebook {
    private(set) var notes: [Note] = []
    
    #if PRESENT
    var countNotesForPresentation: Int = 0
    #endif
    
    public func add(_ note: Note) {
        let checkDuplicate = notes.contains(where: { noteInNotesArray in noteInNotesArray.uid == note.uid})
        if !checkDuplicate {
            notes.append(note)
            DDLogInfo("Заметка добавлена c id: \(note.uid)")
            
            #if PRESENT
            countNotesForPresentation += 1
            print("Используется \(countNotesForPresentation) заметок")
            #endif
        }
    }
    public func remove(with uid: String) {
//        for (index, note) in notes.enumerated() {
//            if note.uid == uid {
//                notes.remove(at: index)
//            }
//        }
        
        self.notes = notes.filter({ $0.uid != uid })
        DDLogInfo("Заметка с id: \(uid) удалена")
        
        #if PRESENT
        countNotesForPresentation -= 1
        print("Используется \(countNotesForPresentation) заметок")
        #endif
        
    }
    public func loadFromFile() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let file = "FileNotebook.txt"
            let fileURL = dir.appendingPathComponent(file)
            //reading
            do{
                let data = try Data(contentsOf: fileURL)
                let dictionaryArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String, Any>]
                for dict in dictionaryArray {
                    if let noteInDict = Note.parse(json: dict) {
                        add(noteInDict)
                    }
                }
                DDLogInfo("JSON загружен")
            } catch let err {
                print("cant read… \(err.localizedDescription)")
            }
            
        }
    }
    public func saveToFile() {
        let file = "FileNotebook.txt"
        var data = Data()
        
        //Создание массива словарей для заметок
        var jsonArray = [[String:Any]]()
        for note in notes {
            jsonArray.append(note.json)
        }
        
        
        do {
            data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                let fileURL = dir.appendingPathComponent(file)
                //writing
                try data.write(to: fileURL)
                DDLogInfo("Заметки сохранены в файл")
            }
        } catch let Error {
            print("Error: \(Error.localizedDescription)")
        }
        
        
    }
    
    public func updateNote(note: Note, indexPath: Int) {
        notes[indexPath] = note
    }
    
    public func loadFromNotes(notes: [Note]) {
        self.notes = notes
    }
    
}
