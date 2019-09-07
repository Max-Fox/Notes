import Foundation



class LoadNotesBackendOperation: AsyncOperation {
    
    var result: [Note]? = []
    let token = "024542290fcc2bbac403340172dca6240198dc2b"
    let urlString = "https://api.github.com/gists/a53fb99cc7eb7f2bd3164ef95f2b33cf"
    var rawURLStrings: [String] = []
    
    override init() {
        super.init()
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    do {
                        let json = try JSONDecoder().decode(Gist.self, from: data)
                        
                        //let notesBack = try JSONDecoder().decode(FileNotebook.self, from: data)
                        print(json)
                        for gist in json.files {
                            if let url = URL(string: gist.value.rawUrl){
                                //self.rawURLStrings.append(gist.value.rawUrl)
                                let getNotes = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                                    if let data = data {
                                        let tempNote = try? JSONDecoder().decode(TempNoteForJson.self, from: data)
                                        let note = tempNote?.convertInNote()
                                        if let note = note {
                                                self.result?.append(note)
                                                print("Заметка добавлена")
                                        }
                                    }
                                })
                                
                                getNotes.resume()
                                
                                print("Progress: \(getNotes.progress.isFinished)")
                                
                            }
                        }
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                    
                }
                
            }
            
            task.resume()
            print("TaskProgress \(task.progress.isFinished)")
        }
        
    }
    
    override func main() {
        
        
        
        print("Error LoadNotesBackendOperation")
        //let note = Note(title: "341", content: "fdarewr", priority: .usual, dateDead: nil)
        //result?.append(Note(title: "31", content: "fda", priority: .usual, dateDead: nil)) // Заглушкка, необходимо получить заметки из бэка
        // result = nil //?.append(Note(title: "321", content: "fda", priority: .usual, dateDead: nil))
        
        
        finish()
        
        
    }
}
