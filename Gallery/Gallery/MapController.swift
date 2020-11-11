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
        //self.navigationItem.title = "Day-1 경주"
        self.initControls()
        self.doLayout()
        self.loadAnnotations()
        mapView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initControls() {
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true
        mapView.delegate = self

        let center = CLLocationCoordinate2DMake(35.819393, 129.208035)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        mapView.setRegion(region, animated: true)
    }

    func doLayout() {
        self.view.addSubview(self.mapView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }

        if !annotation.isKind(of: ImageAnnotation.self) {
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
            }
            return pinAnnotationView
        }
        
        var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
        if view == nil {
            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
        }

        let annotation = annotation as! ImageAnnotation
        view?.image = annotation.image
        view?.annotation = annotation

        return view
    }
    
    var imagetitle = ""
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let gallerycontroller = self.storyboard?.instantiateViewController(identifier: "GalleryController") {
            self.navigationController?.pushViewController(gallerycontroller, animated: true)
            
        }
        if let optionalTitle = view.annotation?.title, let title = optionalTitle {
            imagetitle = title
        }
        print(imagetitle)
    }

    func loadAnnotations() {
        let locations = [
            ["title": "New York, NY",    "latitude": 35.790262, "longitude": 129.332017],
            ["title": "Los Angeles, CA", "latitude": 35.829393, "longitude": 129.218035],
            ["title": "Chicago, IL",     "latitude": 35.830013, "longitude": 129.227206],
            ["title": "Los Angeles, CA", "latitude": 35.819393, "longitude": 129.208035],
            ["title": "Los Angeles, CA", "latitude": 35.809393, "longitude": 129.213035]
        ]

        var myCoordinate : [CLLocationCoordinate2D] = []
        var source1:MKMapItem?
        var source2:MKMapItem?
        var source3:MKMapItem?
        var source4:MKMapItem?
        var destination1:MKMapItem?
        var destination2:MKMapItem?
        var destination3:MKMapItem?
        var destination4:MKMapItem?
        
        for location in locations {
                    let annotation = ImageAnnotation()
                    annotation.title = "\(count).jpg"
                    annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
                    annotation.image = UIImage(named: "불국사\(count).jpeg")
                    self.mapView.addAnnotation(annotation)
                    count = count+1
                    myCoordinate.append(annotation.coordinate)
                }
        
        source1 = MKMapItem( placemark: MKPlacemark(coordinate: myCoordinate[0], addressDictionary: nil))
        source2 = MKMapItem( placemark: MKPlacemark(coordinate: myCoordinate[1], addressDictionary: nil))
        source3 = MKMapItem( placemark: MKPlacemark(coordinate: myCoordinate[2], addressDictionary: nil))
        source4 = MKMapItem( placemark: MKPlacemark(coordinate: myCoordinate[3], addressDictionary: nil))
        destination1 = MKMapItem( placemark: MKPlacemark(coordinate: myCoordinate[1], addressDictionary: nil))
        destination2 = MKMapItem( placemark: MKPlacemark(coordinate: myCoordinate[2], addressDictionary: nil))
        destination3 = MKMapItem( placemark: MKPlacemark(coordinate: myCoordinate[3], addressDictionary: nil))
        destination4 = MKMapItem( placemark: MKPlacemark(coordinate: myCoordinate[4], addressDictionary: nil))
        
        let directionRequest1 = MKDirections.Request()
        directionRequest1.requestsAlternateRoutes = true
        directionRequest1.source = source1
        directionRequest1.destination = destination1
        directionRequest1.transportType = .automobile
        
        let directionRequest2 = MKDirections.Request()
        directionRequest2.requestsAlternateRoutes = true
        directionRequest2.source = source2
        directionRequest2.destination = destination2
        directionRequest2.transportType = .automobile
        
        let directionRequest3 = MKDirections.Request()
        directionRequest3.requestsAlternateRoutes = true
        directionRequest3.source = source3
        directionRequest3.destination = destination3
        directionRequest3.transportType = .automobile
        
        let directionRequest4 = MKDirections.Request()
        directionRequest4.requestsAlternateRoutes = true
        directionRequest4.source = source4
        directionRequest4.destination = destination4
        directionRequest4.transportType = .automobile
        
        
         let directions1 = MKDirections(request: directionRequest1)
         directions1.calculate { (response, error) in
             guard let directionResonse = response else {
                 if let error = error {
                     print("we have error getting directions==\(error.localizedDescription)")
                 }
                 return
             }
             
             let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
             
             let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
         }
        
        let directions2 = MKDirections(request: directionRequest2)
        directions2.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
           self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
           self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        let directions3 = MKDirections(request: directionRequest3)
        directions3.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
           self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
           self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        let directions4 = MKDirections(request: directionRequest4)
        directions4.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
           self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
           self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
            }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4.0

        }
        return polylineRenderer
    }

}
