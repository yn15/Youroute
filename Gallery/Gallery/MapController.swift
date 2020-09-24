//
//  ViewController.swift
//  Maps
//
//  Created by Brandon T on 2017-02-20.
//  Copyright © 2017 XIO. All rights reserved.
//

import UIKit
import MapKit


class ImageAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var colour: UIColor?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
}

class ImageAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.addSubview(self.imageView)

        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
    }

    override var image: UIImage? {
        get {
            return self.imageView.image
        }

        set {
            self.imageView.image = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    //var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var count = 1
    override func viewDidLoad() {
        super.viewDidLoad()


        self.initControls()
        self.doLayout()
        self.loadAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initControls() {
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true
        mapView.delegate = self

        let center = CLLocationCoordinate2DMake(35.819393, 129.208035)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }

    func doLayout() {
        self.view.addSubview(self.mapView)
//        self.mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
            return nil  //Default is to let the system handle it.
        }

        if !annotation.isKind(of: ImageAnnotation.self) {  //Handle non-ImageAnnotations..
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
            }
            return pinAnnotationView
        }

        //Handle ImageAnnotations..
        var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
        if view == nil {
            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
        }

        let annotation = annotation as! ImageAnnotation
        view?.image = annotation.image
        view?.annotation = annotation

        return view
    }


    func loadAnnotations() {
        let locations = [
            ["title": "New York, NY",    "latitude": 35.790262, "longitude": 129.332017],
            ["title": "Los Angeles, CA", "latitude": 35.829393, "longitude": 129.218035],
            ["title": "Chicago, IL",     "latitude": 35.830013, "longitude": 129.227206],
            ["title": "Los Angeles, CA", "latitude": 35.819393, "longitude": 129.208035],
            ["title": "Los Angeles, CA", "latitude": 35.809393, "longitude": 129.213035]
        ]

        
//        let request = NSMutableURLRequest(url: URL(string: "https://www.hknu.ac.kr/sites/kor/images/ci_1.png")!)
//        request.httpMethod = "GET"
//
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
//            if error == nil {
                
        for location in locations {
                    let annotation = ImageAnnotation()
                    annotation.title = location["title"] as? String
                    annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            annotation.image = UIImage(named: "\(count).jpg")
                    self.mapView.addAnnotation(annotation)
                    count = count+1
                    
                }
                
//                let annotation = ImageAnnotation()
//                annotation.coordinate = CLLocationCoordinate2DMake(37.011901, 127.264280)
//                annotation.image = UIImage(data: data!, scale: UIScreen.main.scale)
//                annotation.title = "Toronto"
//                annotation.subtitle = "Yonge & Bloor"


//                DispatchQueue.main.async {
//                    self.mapView.addAnnotation(annotation)
//                }
            }
        //}
    
        //dataTask.resume()
    //}
}

















////
////  MapViewController.swift
////  Gallery
////
////  Created by CY on 2020/07/21.
////  Copyright © 2020 CY. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseUI
//import FirebaseStorage
//import FirebaseFirestoreSwift
//
//class MapController: UIViewController {
//
//    @IBOutlet weak var imageview: UIImageView!
//
//    func downloadimage(imageview:UIImageView){
//
////        let storage = Storage.storage()
////
////        storage.reference(forURL: "gs://youroutehknu.appspot.com/images/test3.jpeg").downloadURL { (url, error) in
////                           let data = NSData(contentsOf: url!)
////                           let image = UIImage(data: data! as Data)
////                            imageview.image = image
////            }
//    }
//
//    func outputroute(imageview:UIImageView){
//
//        let testref = Firestore.firestore().collection("test").document("aa")
//
//        testref.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data()?["bb"] as! String
//                let storage = Storage.storage()
//                storage.reference(forURL: dataDescription).downloadURL { (url, error) in
//                        let data = NSData(contentsOf: url!)
//                        let image = UIImage(data: data! as Data)
//                        imageview.image = image
//                            }
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        outputroute(imageview: imageview)
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
