//
//  GalleryCollectionViewController.swift
//  Notes
//
//  Created by Максим Лисица on 15/07/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class GalleryCollectionViewController: UIViewController {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var imageViews = [UIImageView]()
    var reuseIdentifier = "Cell"
    
    
    var img: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageNames = ["screen_1", "screen_2", "screen_3", "screen_4", "screen_5"]
        for name in imageNames {
            let image = UIImage(named: name)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageViews.append(imageView)
        }
        
        title = "Галерея"
        
        // Do any additional setup after loading the view.
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        //galleryCollectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        
    }
    
    @IBAction func addActionBarButtonItem(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerController.SourceType.photoLibrary;
            //imag.mediaTypes = [kUTTypeImage]
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
    }
    
    
 
    

}
extension GalleryCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(imageViews.count)
        return imageViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        
        cell.imageViewPhoto.image = imageViews[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: "gallerySB") as! PhotoViewController
        destVC.imageViews = imageViews
        destVC.currentImage = indexPath.row
        navigationController?.pushViewController(destVC, animated: true)
    }

}

extension GalleryCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        img = UIImageView(image: tempImage)
        imageViews.append(img!)
        galleryCollectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
}
