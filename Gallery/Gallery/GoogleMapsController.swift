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


class GoogleMapsController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var google_map: GMSMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let camera = GMSCameraPosition.camera(withLatitude: 24.7041, longitude: 77.1025, zoom: 6.0)
//        google_map.camera = camera
//        self.show_maker(position: google_map.camera.target)
//        self.google_map.delegate = self
        //getCurrentLocation()
        
        let sourceLat = 28.704060
        let sourceLng = 77.102493
        
        let destinationLat = 28.459497
        let destinationLng = 77.026634
        
        let sourceLocation = "\(sourceLat),\(sourceLng)"
        let destinationLocation = "\(destinationLat),\(destinationLng)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?orgin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=AIzaSyB_nErUVkzvyiKPAJS4TMGQKjVdUNmmv0M"
        
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {
                return
            }
            do {
                let jsonData = try JSON(data: data)
                let routes = jsonData["routes"].arrayValue
                
                for route in routes {
                    
                
                    
                    let overview_polyline = route["overview_polyline"].dictionary
                    let points = overview_polyline?["points"]?.string
                    let path = GMSPath.init(fromEncodedPath: points ?? "")
//                    let path = GMSMutablePath()
//                    path.add(CLLocationCoordinate2D(latitude: 28.459497, longitude: 77.026634))
//                    path.add(CLLocationCoordinate2D(latitude: 28.704060, longitude: 77.102493))
                    let polyline = GMSPolyline.init(path: path)
//                    polyline.strokeColor = .systemBlue
//                    polyline.strokeWidth = 5.0
                    polyline.map = self.google_map

                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLng)
        sourceMarker.title = "Delhi"
        sourceMarker.snippet = "The capital of India"
        sourceMarker.map = self.google_map
        
        let destinationMaker = GMSMarker()
        destinationMaker.position = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLng)
        destinationMaker.title = "Gurugram"
        destinationMaker.snippet = "The hub of industires"
        destinationMaker.map = self.google_map
        
        let camera = GMSCameraPosition(target: sourceMarker.position, zoom: 10)
        google_map.animate(to: camera)
    }
    
    func getCurrentLocation() {
    // Ask for Authorisation from the User.
    self.locationManager.requestAlwaysAuthorization()
        
    // For use in foreground
    self.locationManager.requestWhenInUseAuthorization()

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
    }
}
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

