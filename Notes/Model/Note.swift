//
//  Model.swift
//  
//
//  Created by Максим Лисица on 20/06/2019.
//

import UIKit
import CocoaLumberjack

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let priority: Priority
    let dateDead: Date?
    
    enum Priority: String {
        case important
        case usual
        case unimportant
    }
    
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), priority: Note.Priority, dateDead: Date?) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.priority = priority
        self.dateDead = dateDead
        DDLogInfo("Заметка с id: \(uid) создана")
    }
    
}

struct TempNoteForJson: Codable {
    let uid: String
    let title: String
    let content: String
    let colorRed: Double
    let colorGreen: Double
    let colorBlue: Double
    let colorAlpha: Int
    let dateDate: Date?
    
    
    func convertInNote() -> Note {
        let note = Note(uid: self.uid, title: self.title, content: self.content, color: UIColor(red: CGFloat(self.colorRed), green: CGFloat(self.colorGreen), blue: CGFloat(self.colorBlue), alpha: CGFloat(self.colorAlpha)), priority: .usual, dateDead: self.dateDate)
        return note
    }
}
