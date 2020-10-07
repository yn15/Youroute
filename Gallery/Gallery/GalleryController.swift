//
//  ViewController.swift
//  Gallery
//
//  Created by CY on 2020/05/14.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class GalleryController: UIViewController {
    
    let images = [ "image1.jpg", "test.jpeg", "1.jpg" , "2.jpg", "3.jpg", "4.jpg", "5.jpg", "test2.jpeg" ]
    //var images : [String] = []
    let fireref = Firestore.firestore()
    let storage = Storage.storage()
    
    
    @IBOutlet weak var GalleryCollectionView: UICollectionView!
    
    
    @IBAction func GoSearch(_ sender: UIButton) {
        if let searchcontroller = self.storyboard?.instantiateViewController(identifier: "SearchController") {
            self.navigationController?.pushViewController(searchcontroller, animated: true)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        storage.reference().child("images").listAll { (result, error) in
//                    if let error = error {
//                        print(error)
//                    }
//                    for item in result.items {
//                        item.getData(maxSize: 1024 * 1024 * 1024) { data, error in
//                        if error != nil {
//                            print("Error: Image could not download!")
//                        } else {
//                        }
//                        }
//                        //self.images.append(item)
//                        //print(self.images)
//                        storage.reference(forURL: item).downloadURL { (url, error) in
//                                    let data = NSData(contentsOf: url!)
//                                    let image = UIImage(data: data! as Data)
//                        cell?.GalleryImage.image = image
//                        }
//                    }
//                }
        
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
        
        storage.reference().child("images").listAll { (result, error) in
            if let error = error {
                print(error)
            }
            for item in result.items {
                print(item)
//                storage.reference(forURL: item as! String).downloadURL { (url, error) in
//                            let data = NSData(contentsOf: url!)
//                            let image = UIImage(data: data! as Data)
//                cell?.GalleryImage.image = image
//                            }
            }
        }
                
        
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
