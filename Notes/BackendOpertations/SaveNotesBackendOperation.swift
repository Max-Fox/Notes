import Foundation

enum NetworkError {
    case unreachable
}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

struct GistSave: Codable {
    let description: String
    var files: [String: GistFileSave]
}
struct GistFileSave: Codable  {
    let content: String
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    var notes: [Note]
    let token = "024542290fcc2bbac403340172dca6240198dc2b"
    let urlString = "https://api.github.com/gists/a53fb99cc7eb7f2bd3164ef95f2b33cf"
    let url: URL
    
    init(notes: [Note]) {
        self.notes = notes
        self.url = URL(string: urlString)!
        
        super.init()
    }
    
    override func main() {
        print("Error SaveNotesBackendOperation")
        
        
        var request = URLRequest(url: url)
        var httpBody = GistSave(description: "Список заметок для ios курса от Яндекса", files: [:])
        
        for note in notes {
            if let dataJson = try? JSONSerialization.data(withJSONObject: note.json, options: []) {
                let content = GistFileSave(content: String(data: dataJson, encoding: .utf8)!)
                httpBody.files["\(note.title)"] = content
            }
            
        }
        
        do {
            let httpBody = try JSONEncoder().encode(httpBody)
            request.httpBody = httpBody
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.httpMethod = "PATCH"
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let taskPost = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            
        }
        taskPost.resume()
        
        
        result = .failure(.unreachable)
        finish()
    }
}
