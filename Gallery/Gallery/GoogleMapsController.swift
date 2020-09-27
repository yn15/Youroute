//
//  GoogleMapsController.swift
//  Gallery
//
//  Created by mac on 2020/09/27.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsController: UIViewController {
    
    @IBOutlet weak var google_map: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 24.7041, longitude: 77.1025, zoom: 6.0)
        google_map.camera = camera
        self.show_maker(position: google_map.camera.target)
        self.google_map.delegate = self
        
    }
    
    func show_maker(position:CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Delie"
        marker.snippet = "Capital of India"
        marker.map = google_map
        
        
    }
}

extension GoogleMapsController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("Clicked Marker")
    }
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("Long press window")
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame:CGRect.init(x: 0, y: 0, width: 200, height: 100))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let title = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.width - 16, height: 15))
        title.text = "Hi there!"
        view.addSubview(title)
        
        return view
    }
    
}
