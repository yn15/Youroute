//
//  MainController.swift
//  Gallery
//
//  Created by CY on 2020/05/19.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class MainController: UIViewController, CLLocationManagerDelegate {
    
//    let images = [ "test.jpeg", "괌.jpeg" , "독일.jpeg", "부산.jpeg", "제주도.jpeg", "test2.jpeg" ]
    
    var images : [String] = []
    let fireref = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBAction func GoLogin(_ sender: Any) {
        if let Logincontroller = self.storyboard?.instantiateViewController(identifier: "LoginViewController"){
            self.navigationController?.pushViewController(Logincontroller, animated: true)
        }
    }
    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var Mymap: MKMapView! //map
    
    var string = ""
    
    let locationManager = CLLocationManager() // map
    
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
        
        test()
        
        //map
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        Mymap.showsUserLocation = true
    }
    
    func test() {
        
        fireref.collection("travel").document("travel").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("error")
                return
            }
            //var Ary : Array = []
            
            let Ary = (document.get("Country") as! Array<Any>)
            //self.images.append(document.get("cc") as! String)
            //print(self.images)
            for Arys in Ary {
                self.images.append(Arys as! String)
                //print(Arys)
            }
            //print(Ary)
            self.MainCollectionView.reloadData()
        }
        
    }
    
    //업데이트 되는 위치정보 표시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last //가장 최근의 위치정보 저장
      myLocation(latitude: (lastLocation?.coordinate.latitude)!, longitude: (lastLocation?.coordinate.longitude)!, delta: 0.01) //delat값이 1보다 작을수록 확대됨. 0.01은 100배확대
        
    }
    
    func myLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, delta: Double){
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let spanValue = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        Mymap.setRegion(locationRegion, animated: true)
        
    }
    

    
}

extension MainController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        let images = [ "test.jpeg", "괌.jpeg" , "독일.jpeg", "부산.jpeg", "제주도.jpeg", "test2.jpeg" ]
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = MainCollectionView.dequeueReusableCell(withReuseIdentifier: "Maincheck", for: indexPath) as? MainSubCell
        
        fireref.collection(images[indexPath.row]).document(images[indexPath.row]).addSnapshotListener { (documentSnapshot, error) in
                        guard let document = documentSnapshot else {
                            print("error")
                            return
                        }
                        let Ary = (document.get("DAY-1") as! Array<Any>)
        //                for Arys in Ary {
        //                    self.imgg.append(Arys as! String)
        //                }
                        //print(Ary)
                        //let storage = Storage.storage()
                        self.storage.reference(forURL: Ary[0] as! String).downloadURL { (url, error) in
                                let data = NSData(contentsOf: url!)
                                let image = UIImage(data: data! as Data)
                            cell?.MainImage.image = image
                                    }
                    }
        
//        self.storage.reference(forURL: "gs://youroutehknu.appspot.com/images/" + images[indexPath.row]).downloadURL { (url, error) in
//            let data = NSData(contentsOf: url!)
//            let image = UIImage(data: data! as Data)
//        cell?.MainImage.image = image
//                }
        
        //cell?.MainImage.image = UIImage(named: images[indexPath.row])
        
//        if let index = images[indexPath.row].range(of: ".")?.lowerBound {
//            let substring = images[indexPath.row][..<index]
//            string = String(substring)
//        }//확장자 제거
        
        cell?.MainLabel.text = images[indexPath.row]
        
        
        
        cell?.MainImage.layer.cornerRadius = 70
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        
//        if let index = images[indexPath.row].range(of: ".")?.lowerBound {
//            let substring = images[indexPath.row][..<index]
//            string = String(substring)
//        }//확장자 제거
        
        move.rcvlabel = images[indexPath.row]
        self.navigationController?.pushViewController(move, animated: true)
        
    }
    
    
}
