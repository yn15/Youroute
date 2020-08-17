//
//  MainController.swift
//  Gallery
//
//  Created by CY on 2020/05/19.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import MapKit

class MainController: UIViewController, CLLocationManagerDelegate {
    
    let images = [ "test.jpeg", "1.jpg" , "2.jpg", "3.jpg", "4.jpg", "5.jpg", "test2.jpeg" ]
    
    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var Mymap: MKMapView!
    
    let locationManager = CLLocationManager()
    
    @IBAction func GoTravel(_ sender: UIButton) {
        
        if let travelcontroller = self.storyboard?.instantiateViewController(identifier: "TravelController"){
            self.navigationController?.pushViewController(travelcontroller, animated: true)
        }
    }
    
    @IBAction func GoGallery(_ sender: UIButton) {
        
        if let gallerycontroller = self.storyboard?.instantiateViewController(identifier: "GalleryController") {
            self.navigationController?.pushViewController(gallerycontroller, animated: true)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        Mymap.showsUserLocation = true
        
        
        
    }
    
}

extension MainController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let images = [ "test.jpeg", "1.jpg" , "2.jpg", "3.jpg", "4.jpg", "5.jpg", "test2.jpeg" ]
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = MainCollectionView.dequeueReusableCell(withReuseIdentifier: "Maincheck", for: indexPath) as? MainSubCell
        
        cell?.MainImage.image = UIImage(named: images[indexPath.row])
        cell?.MainLabel.text = images[indexPath.row]
        
        cell?.MainImage.layer.cornerRadius = 70
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        
        move.rcvlabel = images[indexPath.row]
        self.navigationController?.pushViewController(move, animated: true)
        
    }
    
    
}
