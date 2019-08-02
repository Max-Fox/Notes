//
//  ChoseColorViewController.swift
//  Notes
//
//  Created by Максим Лисица on 11/07/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

protocol ChoseColorViewControllerDelegate {
    func getChosedColor(color: UIColor)
}

@IBDesignable
class ChoseColorViewController: UIViewController {
    
    @IBOutlet weak var chosenColorView: UIView!
    @IBOutlet weak var chosenColorLabel: UILabel!
    @IBOutlet weak var colorPickerView: HSBColorPicker!
    @IBOutlet weak var sliderBrightness: UISlider!
    
    var delegate: ChoseColorViewControllerDelegate?
    
    var chosedFirstColor: UIColor!
    var currentColor: UIColor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.chosenColorView.layer.cornerRadius = 5
        self.chosenColorView.layer.borderWidth = 1
        self.chosenColorView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.colorPickerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.colorPickerView.layer.borderWidth = 1
        
        
       
        if(UIColor.compareColors(c1: chosedFirstColor, c2: UIColor(patternImage: UIImage(named: "choseColor")!))){
            colorPickerView.choseColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            chosenColorView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            chosenColorLabel.text = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).toHexString()
            chosedFirstColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            chosenColorView.backgroundColor = chosedFirstColor
            chosenColorLabel.text = chosedFirstColor.toHexString()
            colorPickerView.choseColor = chosedFirstColor
        }
       
        
        
       
        
        currentColor = chosedFirstColor
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(chosedColor), name: NSNotification.Name(rawValue: "ColorWasChange"), object: nil)
    }
    
    @objc func chosedColor(){
        currentColor = colorPickerView.getChoseColor()
        chosenColorView.backgroundColor = currentColor
        chosenColorLabel.text = currentColor.toHexString()
        sliderBrightness.value = 0.0
    }
    
    
    
    @IBAction func buttonDoneAction(_ sender: Any) {
        delegate?.getChosedColor(color: currentColor)
        //rootVC.setChosedColor(color: colorPickerView.getChoseColor())
        //ViewController.shared.title = "Color"
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func slideBarAction(_ sender: Any) {
        var color = colorPickerView.getChoseColor()
        color = color.adjust(brightnessBy: CGFloat(sliderBrightness!.value))
        currentColor = color
        chosenColorView.backgroundColor = currentColor
        chosenColorLabel.text = currentColor.toHexString()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIColor {
    ///Сравнение двух цветов
    static func compareColors(c1:UIColor, c2:UIColor) -> Bool{
        
        
        var red:CGFloat = 0
        var green:CGFloat  = 0
        var blue:CGFloat = 0
        var alpha:CGFloat  = 0
        c1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var red2:CGFloat = 0
        var green2:CGFloat  = 0
        var blue2:CGFloat = 0
        var alpha2:CGFloat  = 0
        c2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return (Int(green*255) == Int(green2*255))
        
    }
}
