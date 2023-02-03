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
        
        let location1 = CLLocationCoordinate2D(latitude: 41.034755, longitude: 28.861355)
        let location2 = CLLocationCoordinate2D(latitude: 41.01, longitude: 28.87)
        let location3 = CLLocationCoordinate2D(latitude: 41.03, longitude: 28.89)
        let location4 = CLLocationCoordinate2D(latitude: 41.04, longitude: 28.86)
        let location5 = CLLocationCoordinate2D(latitude: 41.02, longitude: 28.88)
        let location6 = CLLocationCoordinate2D(latitude: 41.05, longitude: 28.87)
        let location7 = CLLocationCoordinate2D(latitude: 41.03, longitude: 28.90)
        let location8 = CLLocationCoordinate2D(latitude: 41.01, longitude: 28.85)
            
        openInMap(locations: [location1, location2, location3,location4, location5, location6, location7, location8])
        
        super.viewDidLoad()

        
    }
    
    func openInMap(locations: [CLLocationCoordinate2D]) {
        var mapItems: [MKMapItem] = []
        for location in locations {
            let destinationPlaceMark = MKPlacemark(coordinate: location, addressDictionary: nil)
            let destinationItem = MKMapItem(placemark: destinationPlaceMark)
            mapItems.append(destinationItem)
        }

        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]

        MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
    }


}
