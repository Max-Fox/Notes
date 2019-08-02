import UIKit
import CocoaLumberjack

extension Note {
    var json: [String : Any] {
        var dict = [String: Any]()
        dict["title"] = self.title
        dict["content"] = self.content
        dict["uid"] = self.uid
        
        if (self.color != #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) {
            //Получение цвета
            var redColor: CGFloat = 0
            var blueColor: CGFloat = 0
            var greenColor: CGFloat = 0
            var alphaColor: CGFloat = 0
            
            self.color.getRed(&redColor, green: &greenColor, blue: &blueColor, alpha: &alphaColor)
            
            dict["colorRed"] = Float.init(redColor)
            dict["colorGreen"] = Float.init(greenColor)
            dict["colorBlue"] = Float.init(blueColor)
            dict["colorAlpha"] = Float.init(alphaColor)
            //Загрузили цвет в JSON
        }
        
        //Сохраняем приоритет
        if self.priority != .usual {
            dict["priority"] = self.priority.rawValue
        }
        
        //Сохраняем дату
        if let dDead = self.dateDead {
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dict["dateDead"] = fmt.string(from: dDead)
        }
        
        DDLogInfo("Заметка конвертирована в JSON")
        return dict
    }
    
    static func parse(json: [String: Any]) -> Note? {
        //проверяем наличие uid
        let jsonUid = (json["uid"] as? String) ?? UUID().uuidString
        
        guard let jsonTitle = json["title"] as? String else { return nil }
        guard let jsonContent = json["content"] as? String else { return nil }
        
        
        var jsonPriority = json["priority"] as? String
        if jsonPriority == nil {
            jsonPriority = "usual"
        }
        
        
        var dateDead: Date?
        let jsonDateDead = json["dateDead"] as? String
        if jsonDateDead != nil {
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateDead = fmt.date(from: jsonDateDead!)
        }
        
        //Проверяем наличие цвета
        let jsonColorRed = json["colorRed"] as? Float
        let jsonColorGreen = json["colorGreen"] as? Float
        let jsonColorBlue = json["colorBlue"] as? Float
        let jsonColorAlpha = json["colorAlpha"] as? Float
        let color: UIColor
        
        if let red = jsonColorRed, let blue = jsonColorBlue, let green = jsonColorGreen, let alpha = jsonColorAlpha {
            color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        } else {
            color = .white
        }
        
        DDLogInfo("Получена заметка из JSON")
        
        return Note(uid: jsonUid, title: jsonTitle, content: jsonContent, color: color,
                    priority: self.Priority.init(rawValue: jsonPriority!)!, dateDead: dateDead)
    }
    
}
