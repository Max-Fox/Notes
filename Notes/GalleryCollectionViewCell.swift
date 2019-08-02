//
//  GalleryCollectionViewCell.swift
//  Notes
//
//  Created by Максим Лисица on 15/07/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageViewPhoto.contentMode = .scaleAspectFit
        imageViewPhoto.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        imageViewPhoto.layer.borderWidth = 1
        
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 1
    }
}
