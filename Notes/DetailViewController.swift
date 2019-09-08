//
//  ViewController.swift
//  Notes
//
//  Created by Максим Лисица on 29/06/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit
//import CocoaLumberjack

protocol DetailViewControllerDelegate {
    func updateNote(note: Note, indexPath: Int)
    func reloadTableView()
}

class DetailViewController: UIViewController, ChoseColorViewControllerDelegate {
    
    var delegate: DetailViewControllerDelegate?
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fileNotebook: FileNotebook!
    //static var shared = DetailViewController()
    
    @IBOutlet weak var collectionViewConstrain: NSLayoutConstraint!
    @IBOutlet weak var collectionViewColor: UICollectionView!
    @IBOutlet weak var isUseDestroyDateSwitch: UISwitch!
    
    @IBOutlet weak var titleNoteLabel: UITextField!
    @IBOutlet weak var contentNoteTextView: UITextView!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    
    
    var arrayColorForCollectionView: [UIColor] = [#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 0.1380086839, green: 0.9187199473, blue: 0.05004646629, alpha: 1),#colorLiteral(red: 1, green: 0.108322438, blue: 0, alpha: 1), UIColor(patternImage: UIImage(named: "choseColor")!) ]
    var choseColorIndex: Int = 0
    
    var currentNote: Note!
    var currentIndexNote: Int?
    
    var noteForEditing: Note!
    var contentNoteForEditing: String = ""
    var titleNoteForEditing: String = ""
    var colorNoteForEditing: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    var operationQueue = OperationQueue()
    var backendOperationQueue = OperationQueue()
    var dbOperationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileNotebook = appDelegate.fileNotebook
        //Создаем пустую заметку и необходимые переменные (чтобы сохранять новую заметку при переопределении)
        contentNoteForEditing = currentNote.content
        titleNoteForEditing = currentNote.title
        colorNoteForEditing = currentNote.color
        
        noteForEditing = Note(title: titleNoteForEditing, content: contentNoteForEditing, color: colorNoteForEditing, priority: .usual, dateDead: nil)
        
        
        //Заполняем Controller данными
        titleNoteLabel.text = currentNote.title
        contentNoteTextView.text = currentNote.content
        
        if currentNote.color != arrayColorForCollectionView[1] && currentNote.color != arrayColorForCollectionView[2] {
            arrayColorForCollectionView[0] = currentNote.color
        }
        
        
        if currentNote.color == arrayColorForCollectionView[1] {
            choseColorIndex = 1
        } else if currentNote.color == arrayColorForCollectionView[2] {
            choseColorIndex = 2
        }
        
        //Добавляем событие на изменение значения
        titleNoteLabel.addTarget(self, action: #selector(changeValueTextField), for: .editingDidEnd)
        
        
        
        contentNoteTextView.delegate = self
        
        //Проверяем видимость DatePicker через переменную dateDead
        if(currentNote.dateDead == nil) {
            isUseDestroyDateSwitch.isOn = false
        } else {
            isUseDestroyDateSwitch.isOn = true
        }
        checkVisibleDatePicker()
        
        
        
    }
    
    
    
    //MARK: - Уведомления для того, чтобы узнать когда необходимо скрывать клавиатуру
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(){
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    @objc func keyboardWillHide(){
        if keyboardDismissTapGesture != nil {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    @objc func dismisKeyboard() {
        view.endEditing(true)
    }
    //END MARK
    
    
    
    @objc func changeValueTextField() {
        print("ValueWasChange")
        
        titleNoteForEditing = titleNoteLabel.text ?? ""
        
        updateCurrentNote()
        
    }
    
    @IBAction func useDestroyDateSwitchAction(_ sender: Any) {
        checkVisibleDatePicker()
        
    }
    
    func checkVisibleDatePicker() {
        if (isUseDestroyDateSwitch.isOn == true) {
            destroyDatePicker.isHidden = false
            destroyDatePicker.frame = CGRect(x: 0, y: 216, width: 398, height: 216)
            collectionViewConstrain.constant = 258
            
            destroyDatePicker.date = currentNote.dateDead ?? Date.init()
            
        } else {
            destroyDatePicker.isHidden = true
            destroyDatePicker.frame = CGRect(x: 0, y: 216, width: 398, height: 0)
            collectionViewConstrain.constant = 25
            
            updateCurrentNote()
            
        }
    }
    
    @IBAction func changeDataPickerValue(_ sender: UIDatePicker) {
        let date = sender.date
        updateCurrentNote(dateDead: date)
    }
    
    ///Функция обновления заметки
    func updateCurrentNote(dateDead: Date? = nil) {
        noteForEditing = Note(title: titleNoteForEditing, content: contentNoteForEditing, color: colorNoteForEditing, priority: .usual, dateDead: dateDead)
        
        let saveOperation = SaveNoteOperation(note: noteForEditing, index: currentIndexNote ?? 0, notebook: fileNotebook, backendQueue: backendOperationQueue, dbQueue: dbOperationQueue)
        
        operationQueue.addOperation(saveOperation)
        
        delegate?.reloadTableView()
        
        //delegate?.updateNote(note: noteForEditing, indexPath: currentIndexNote ?? 0)
    }
    
    
    
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionColorCell
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTap(gesture:)))
        
        cell.gestureRecognizer = longPressRecognizer
        
        //cell.colorBackgroundCell = arrayColorForCollectionView[indexPath.row]
        cell.backgroundColor = arrayColorForCollectionView[indexPath.row]
        
        
        
        if indexPath.row == choseColorIndex {
            cell.isChose = true
        }
        //cell = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        if (indexPath.row == 3) {
            
            //cell.backgroundColor = UIColor(patternImage: UIImage(named: "choseColor")!)
            longPressRecognizer.minimumPressDuration = 0.5
            //longPressRecognizer.delegate = self
            longPressRecognizer.delaysTouchesBegan = true
            cell.addGestureRecognizer(longPressRecognizer)
            
            
        }
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Перепроверить
        guard (indexPath.row != 3 || !UIColor.compareColors(c1: arrayColorForCollectionView[indexPath.row], c2: UIColor(patternImage: UIImage(named: "choseColor")!))) else { return }
        
        
        choseColorIndex = indexPath.row
        collectionView.reloadData()
        //print("Reload \(choseColorIndex)")
        print("ColorWasChange")
        
        colorNoteForEditing = arrayColorForCollectionView[indexPath.row]
        
        updateCurrentNote()
        
        
    }
    @objc func longTap(gesture : UILongPressGestureRecognizer!){
        if gesture.state == UIGestureRecognizer.State.began {
            //When lognpress is start or running
            print("LONG TAP")
            performSegue(withIdentifier: "colorPickerSegue", sender: nil)
            //            let choseColorVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerVC") ChoseColorViewController()
            //            choseColorVC.delegate = self
            //            choseColorVC.chosedFirstColor = arrayColorForCollectionView[3]
            //            present(choseColorVC, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorPickerSegue" {
            let choseColorVC = segue.destination as! ChoseColorViewController
            choseColorVC.delegate = self
            choseColorVC.chosedFirstColor = arrayColorForCollectionView[3]
        }
    }
    
    func getChosedColor(color: UIColor) {
        arrayColorForCollectionView[3] = color
        choseColorIndex = 3
        collectionViewColor.reloadData()
        
        colorNoteForEditing = color
        updateCurrentNote()
    }
    
}
extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Editing content")
        contentNoteForEditing = textView.text
        
        updateCurrentNote()
    }
}

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    public func adjust(hueBy hue: CGFloat = 0, saturationBy saturation: CGFloat = 0, brightnessBy brightness: CGFloat = 0) -> UIColor {
        
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0
        
        if getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: currentHue + hue,
                           saturation: currentSaturation + saturation,
                           brightness: currentBrigthness + brightness,
                           alpha: currentAlpha)
        } else {
            return self
        }
    }
    
}
