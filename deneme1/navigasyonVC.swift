//
//  navigasyonVC.swift
//  deneme1
//
//  Created by Kadir Dündar on 2.02.2023.
//

import UIKit
import MapKit
import CoreLocation

class navigasyonVC: UIViewController {

    override func viewDidLoad() {
        
        let destinationLocation = CLLocationCoordinate2D(latitude: 41.034755, longitude: 28.861355)
        
        openInMap(location: destinationLocation)
        super.viewDidLoad()

        
    }
    
    func openInMap(location : CLLocationCoordinate2D) {
        
        let destinationPlaceMark = MKPlacemark(coordinate: location, addressDictionary: nil)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        destinationItem.openInMaps(launchOptions: launchOptions)
        
        
    }

}
