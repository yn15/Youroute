//
//  MKMapViewDelegate.swift
//  Gallery
//
//  Created by mac on 2020/10/14.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import MapKit

func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
    renderer.lineWidth = 5.0
    return renderer;
    
}
