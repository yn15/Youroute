//
//  ViewController.swift
//  Gallery
//
//  Created by CY on 2020/05/14.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit

class GalleryController: UIViewController {
    
    let images = [ "image1.jpg", "test.jpeg", "1.jpg" , "2.jpg", "3.jpg", "4.jpg", "5.jpg", "test2.jpeg" ]
    
    @IBOutlet weak var GalleryCollectionView: UICollectionView!
    
    
    @IBAction func GoSearch(_ sender: UIButton) {
        if let searchcontroller = self.storyboard?.instantiateViewController(identifier: "SearchController") {
            self.navigationController?.pushViewController(searchcontroller, animated: true)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
}

extension GalleryController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = GalleryCollectionView.dequeueReusableCell(withReuseIdentifier: "Gallerycheck", for: indexPath) as? GallerySubCell
        
        cell?.GalleryImage.image = UIImage(named: images[indexPath.row])
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "StoryController") as! StoryController
        
        move.rcvimage = UIImage(named: images[indexPath.row])
        self.navigationController?.pushViewController(move, animated: true)
        
    }
    
    
}
