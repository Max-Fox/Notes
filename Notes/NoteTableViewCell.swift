//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Максим Лисица on 15/07/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var colorImageView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        isHidden = false
        isSelected = false
        isHighlighted = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorImageView.layer.cornerRadius = 5
        colorImageView.layer.borderWidth = 1
        colorImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
