//
//  GoogleMapsController.swift
//  Gallery
//
//  Created by mac on 2020/09/27.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON
import MapKit


class GoogleMapsController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var swich: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.requestWhenInUseAuthorization()
        
//        let locationManager = CLLocationManager()
//        var currentLoc: CLLocation!
//        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//        CLLocationManager.authorizationStatus() == .authorizedAlways) {
//           currentLoc = locationManager.location
            
//           let coordinateOne = CLLocationCoordinate2D(latitude: currentLoc.coordinate.latitude, longitude:currentLoc.coordinate.longitude)
//
//           let coordinateTwo = CLLocationCoordinate2D(latitude: currentLoc.coordinate.latitude,longitude:currentLoc.coordinate.longitude)
//
//            self.getDirections(loc1: coordinateOne, loc2: coordinateTwo)
//        }
        
        let coordinateOne = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 40.586746)!, longitude: CLLocationDegrees(exactly: -108.610891)!)

        let coordinateTwo = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 42.564874)!, longitude: CLLocationDegrees(exactly: -102.125547)!)
        self.getDirections(loc1: coordinateOne, loc2: coordinateTwo)
        
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getDirections(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) {
       let source = MKMapItem(placemark: MKPlacemark(coordinate: loc1))
       source.name = "Your Location"
       let destination = MKMapItem(placemark: MKPlacemark(coordinate: loc2))
       destination.name = "Destination"
       MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
}


func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // Don't want to show a custom image if the annotation is the user's location.
    guard !(annotation is MKUserLocation) else {
        return nil
    }

    // Better to make this class property
    let annotationIdentifier = "AnnotationIdentifier"

    var annotationView: MKAnnotationView?
    if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
        annotationView = dequeuedAnnotationView
        annotationView?.annotation = annotation
    }
    else {
        let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView = av
    }

    if let annotationView = annotationView {
        // Configure your annotation view here
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "yourImage")
    }

    return annotationView
}

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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//     let renderer = MKPolylineRenderer(overlay: overlay)
//    renderer.strokeColor = UIColor.red
//    renderer.lineWidth = 4.0
//    return renderer
//}
//
//    func drawPlaceMark() {
//
//        for (x,y) in location! {
//            sourceLocation = CLLocationCoordinate2D(latitude: x, longitude: y)
//
//            let destinationPlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
//
//            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//            let sourceAnnotation = MKPointAnnotation()
//            sourceAnnotation.title = placeAnnotation?[indexPoint]
//
//            indexPoint = indexPoint + 1
//
//            if let location = destinationPlacemark.location {
//                sourceAnnotation.coordinate = location.coordinate
//            }
//            self.mapView.showAnnotations([sourceAnnotation,sourceAnnotation], animated: true )
//
//
//            // Calculate the direction and draw line
//            let directionRequest = MKDirections.Request()
//            directionRequest.source = destinationMapItem
//
//            directionRequest.destination = destinationMapItem
//            directionRequest.transportType = .walking
//
//            let directions = MKDirections(request: directionRequest)
//
//            directions.calculate {
//                (response, error) -> Void in
//
//                guard let response = response else {
//                    if let error = error {
//                        print("Error: \(error)")
//                    }
//                    return
//                }
//
//                let route = response.routes[0]
//                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
//
//                let rect = route.polyline.boundingMapRect
//                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
//            }
//        }
//    }
//
//
//}
//
//
//
//
//
//
//
        
        
        
        
// here from
//        let path = GMSMutablePath()
//        let sourceMarker = GMSMarker()
//        path.add(CLLocationCoordinate2D(latitude: 37.778483, longitude: -122.513960))
//        path.add(CLLocationCoordinate2D(latitude: 37.706753, longitude: -122.418677))
//        let sourceLat = 37.778483
//        let sourceLng = -122.513960
//        sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLng)
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeColor = .black
//        polyline.strokeWidth = 5
//        polyline.map = google_map
//        let camera = GMSCameraPosition(target: sourceMarker.position, zoom: 10)
//        google_map.animate(to: camera)
// here too
        
        
        
        // Do any additional setup after loading the view.
//        let camera = GMSCameraPosition.camera(withLatitude: 24.7041, longitude: 77.1025, zoom: 6.0)
//        google_map.camera = camera
//        self.show_maker(position: google_map.camera.target)
//        self.google_map.delegate = self
        //getCurrentLocation()
//        let sourceLat = 28.704060
//        let sourceLng = 77.102493
//
//        let destinationLat = 28.459497
//        let destinationLng = 77.026634
//
//        let sourceLocation = "\(sourceLat),\(sourceLng)"
//        let destinationLocation = "\(destinationLat),\(destinationLng)"
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?orgin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=AIzaSyB_nErUVkzvyiKPAJS4TMGQKjVdUNmmv0M"
//
//        Alamofire.request(url).responseJSON { (response) in
//            guard let data = response.data else {
//                return
//            }
//            do {
//                let jsonData = try JSON(data: data)
//                let routes = jsonData["routes"].arrayValue
//
//                for route in routes {
//
//
//
//                    let overview_polyline = route["overview_polyline"].dictionary
//                    let points = overview_polyline?["points"]?.string
//                    let path = GMSPath.init(fromEncodedPath: points ?? "")
////                    let path = GMSMutablePath()
////                    path.add(CLLocationCoordinate2D(latitude: 28.459497, longitude: 77.026634))
////                    path.add(CLLocationCoordinate2D(latitude: 28.704060, longitude: 77.102493))
//                    let polyline = GMSPolyline.init(path: path)
////                    polyline.strokeColor = .systemBlue
////                    polyline.strokeWidth = 5.0
//                    polyline.map = self.google_map
//
//                }
//            }
//            catch let error {
//                print(error.localizedDescription)
//            }
//        }
//
//        let sourceMarker = GMSMarker()
//        sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLng)
//        sourceMarker.title = "Delhi"
//        sourceMarker.snippet = "The capital of India"
//        sourceMarker.map = self.google_map
//
//        let destinationMaker = GMSMarker()
//        destinationMaker.position = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
//        destinationMaker.title = "Gurugram"
//        destinationMaker.snippet = "The hub of industires"
//        destinationMaker.map = self.google_map
//
//        let camera = GMSCameraPosition(target: sourceMarker.position, zoom: 10)
//        google_map.animate(to: camera)
//    }
//
//    func getCurrentLocation() {
//    // Ask for Authorisation from the User.
//    self.locationManager.requestAlwaysAuthorization()
//
//    // For use in foreground
//    self.locationManager.requestWhenInUseAuthorization()

//    if CLLocationManager.locationServicesEnabled() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.startUpdatingLocation()
//    }
        
//    var marker = GMSMarker()
//    func show_maker(position:CLLocationCoordinate2D){
//
//        marker.position = position
//        marker.title = "Delie"
//        marker.snippet = "Capital of India"
//        marker.map = google_map
//
//    }
//    }
//}
//extension GoogleMapsController : GMSMapViewDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//            let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude, longitude: locValue.longitude, zoom: 15.0)
//            google_map.camera = camera
//            self.google_map.delegate = self
////           print("locations = \(locValue.latitude) \(locValue.longitude)")
//        }
//
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        print("Clicked Marker")
//    }
//    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
//        print("Long press window")
//    }
////    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
////        let view = UIView(frame:CGRect.init(x: 0, y: 0, width: 200, height: 100))
////        view.backgroundColor = UIColor.white
////        view.layer.cornerRadius = 6
////
////        let title = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.width - 16, height: 15))
////        title.text = "Hi there!"
////        view.addSubview(title)
////
////        return view
////    }
//    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
//        print("Dagging Start")
//    }
//    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
//        print("Did Drag")
//    }
//    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
//        print("End Start")
//    }
////    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
////        marker.position = coordinate
////    }
//    }
//

//}
}
