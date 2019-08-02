//
//  CollectionColorCell.swift
//  Notes
//
//  Created by Максим Лисица on 09/07/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class CollectionColorCell: UICollectionViewCell {
    
    var colorBackgroundCell: UIColor?
    var isChose: Bool = false
    
    var gestureRecognizer: UIGestureRecognizer!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.removeGestureRecognizer(gestureRecognizer)
        self.isChose = false
        isHidden = false
        isSelected = false
        isHighlighted = false
        
        //self.backgroundColor = colorBackgroundCell
    }

    override func layoutSubviews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        //self.backgroundColor = self.colorBackgroundCell
        //colorBackgroundCell = nil
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if (isChose) {
            let path = getTrianglePath(in: CGRect(x: self.bounds.maxX - 20, y: 0, width: 20, height: 20))
            path.stroke()
        }
    }
    func getTrianglePath(in rect: CGRect) -> UIBezierPath{
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.width / 2)
        path.lineWidth = 1.5
        path.move(to: CGPoint(x: rect.minX + 5, y: rect.minY + 5))
        path.addLine(to: CGPoint(x: rect.midX - 3, y: rect.maxY - 3))
        path.addLine(to: CGPoint(x: rect.maxX - 2, y: rect.minY + 3))
        return path
        
    }
}
