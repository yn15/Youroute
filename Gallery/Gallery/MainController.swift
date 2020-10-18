import UIKit
import MapKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class MainController: UIViewController, CLLocationManagerDelegate {
    
    var images : [String] = []
    let fireref = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var MainCollectionView: UICollectionView!
    @IBOutlet weak var Mymap: MKMapView!
    
    var string = ""
    
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
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        test()
        
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
            
            let Ary = (document.get("Country") as! Array<Any>)
            for Arys in Ary {
                self.images.append(Arys as! String)
            }
            self.MainCollectionView.reloadData()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
      myLocation(latitude: (lastLocation?.coordinate.latitude)!, longitude: (lastLocation?.coordinate.longitude)!, delta: 0.01)
        
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

                        self.storage.reference(forURL: Ary[0] as! String).downloadURL { (url, error) in
                                let data = NSData(contentsOf: url!)
                                let image = UIImage(data: data! as Data)
                            cell?.MainImage.image = image
                                    }
                    }
    
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
