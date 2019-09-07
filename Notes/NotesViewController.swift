//
//  NotesViewController.swift
//  Notes
//
//  Created by Максим Лисица on 15/07/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit



class NotesViewController: UIViewController {
    
    var reuseIdentifier = "Cell"
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fileNotebook: FileNotebook!
    
    @IBOutlet weak var noteTableView: UITableView!
    
    var operationQueue = OperationQueue()
    var backOperationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileNotebook = appDelegate.fileNotebook
        // Do any additional setup after loading the view.
        noteTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        title = "Заметки"
        
        
        let operationLoad = LoadNotesOperation(notebook: fileNotebook, opQueue: backOperationQueue)
        operationQueue.addOperation(operationLoad)
      //  operationQueue.waitUntilAllOperationsAreFinished()
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNoteSegue" {
            let destVC = segue.destination as! DetailViewController
            let emptyNote = Note(title: "Новая заметка", content: "Текст заметки", color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), priority: .usual, dateDead: nil)
            fileNotebook.add(emptyNote)
            destVC.currentNote = emptyNote
            destVC.currentIndexNote = fileNotebook.notes.count - 1
            destVC.delegate = self
        }
    }
    
    @IBAction func editTableAction(_ sender: UIBarButtonItem) {
        if noteTableView.isEditing {
            print("Enter")
            noteTableView.isEditing = false
            editBarButtonItem.title = "Edit"
        } else {
            noteTableView.isEditing = true
            editBarButtonItem.title = "Done"
        }
        //noteTableView.isEditing = !noteTableView.isEditing
        noteTableView.reloadData()
        
        //print("EditPress \(noteTableView.isEditing)")
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let removeOperation = RemoveNotesOperation(notebook: fileNotebook, id: fileNotebook.notes[indexPath.row].uid)
            operationQueue.addOperation(removeOperation)
            //fileNotebook.remove(with: fileNotebook.notes[indexPath.row].uid)
            tableView.reloadData() // Изменить
         
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        if tableView.isEditing {
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    
}
extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNotebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        cell.colorImageView.backgroundColor = fileNotebook.notes[indexPath.row].color
        cell.titleLabel.text = fileNotebook.notes[indexPath.row].title
        cell.detailLabel.text = fileNotebook.notes[indexPath.row].content
        cell.detailLabel.numberOfLines = 5
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        detailVC.currentNote = fileNotebook.notes[indexPath.row]
        detailVC.currentIndexNote = indexPath.row
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    
}
extension NotesViewController: DetailViewControllerDelegate {
    func reloadTableView() {
        noteTableView.reloadData()
    }
    
    func updateNote(note: Note, indexPath: Int) {
        self.fileNotebook.updateNote(note: note, indexPath: indexPath)
        noteTableView.reloadData()
    }
    
    
}
