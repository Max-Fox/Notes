//
//  PhotoViewController.swift
//  Notes
//
//  Created by Максим Лисица on 15/07/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var scrollViewPhoto: UIScrollView!
    
    var imageViews = [UIImageView]()
    
    var currentImage: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        let imageNames = ["screen_1", "screen_2", "screen_3", "screen_4", "screen_5"]
//        for name in imageNames {
//            let image = UIImage(named: name)
//            let imageView = UIImageView(image: image)
//            imageView.contentMode = .scaleAspectFit
//            scrollViewPhoto.addSubview(imageView)
//            imageViews.append(imageView)
//        }
        for imageView in imageViews {
            imageView.contentMode = .scaleAspectFit
            scrollViewPhoto.addSubview(imageView)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = scrollViewPhoto.frame.size
            imageView.frame.origin.x  = scrollViewPhoto.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        let contentWidth = scrollViewPhoto.frame.width * CGFloat(imageViews.count)
        scrollViewPhoto.contentSize = CGSize(width: contentWidth, height: scrollViewPhoto.frame.height)
        scrollViewPhoto.isPagingEnabled = true
        
        //Перемещаемся сразу к выбранной фотографии
        scrollViewPhoto.contentOffset = CGPoint(x: scrollViewPhoto.frame.width * CGFloat(currentImage!), y: 0)
    }
    
    
}
