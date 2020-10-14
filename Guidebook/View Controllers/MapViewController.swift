//
//  MapViewController.swift
//  Guidebook
//
//  Created by John Kouris on 10/12/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    var place: Place?
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let place = place else { return }
        
        // Create a CLLocationCoordinate2D
        let location = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long)
        
        // Create a pin
        let pin = MKPointAnnotation()
        pin.coordinate = location
        
        // Add it to the map
        mapView.addAnnotation(pin)
        
        // Create a region to zoom to
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 100, longitudinalMeters: 100)
        
        // Set the region
        mapView.setRegion(region, animated: false)
    }
    
}
