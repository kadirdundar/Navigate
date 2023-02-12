import UIKit
import MapKit
import CoreLocation

class navigasyonVC: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        
        let location1 = CLLocationCoordinate2D(latitude: 41.034755, longitude: 28.861355)
        let location2 = CLLocationCoordinate2D(latitude: 41.01, longitude: 28.87)
        let location3 = CLLocationCoordinate2D(latitude: 41.03, longitude: 28.89)
        let location4 = CLLocationCoordinate2D(latitude: 41.04, longitude: 28.86)
        let location5 = CLLocationCoordinate2D(latitude: 41.02, longitude: 28.88)
        let location6 = CLLocationCoordinate2D(latitude: 41.05, longitude: 28.87)
        let location7 = CLLocationCoordinate2D(latitude: 41.03, longitude: 28.90)
        let location8 = CLLocationCoordinate2D(latitude: 41.01, longitude: 28.85)
        let location9 = CLLocationCoordinate2D(latitude: 41.06, longitude: 28.86)
        let location10 = CLLocationCoordinate2D(latitude: 41.07, longitude: 28.89)
        let location11 = CLLocationCoordinate2D(latitude: 41.05, longitude: 28.88)
        let location12 = CLLocationCoordinate2D(latitude: 41.04, longitude: 28.84)
        let location13 = CLLocationCoordinate2D(latitude: 41.02, longitude: 28.86)
        let location14 = CLLocationCoordinate2D(latitude: 41.01, longitude: 28.89)
        let location15 = CLLocationCoordinate2D(latitude: 41.03, longitude: 28.86)
        let location16 = CLLocationCoordinate2D(latitude: 41.06, longitude: 28.88)
        let location17 = CLLocationCoordinate2D(latitude: 41.05, longitude: 28.90)
        let location18 = CLLocationCoordinate2D(latitude: 41.04, longitude: 28.89)
        
        let locations = [CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                         CLLocationCoordinate2D(latitude: 37.8074, longitude: -122.2719),
                         CLLocationCoordinate2D(latitude: 37.7648, longitude: -122.4230),
                         CLLocationCoordinate2D(latitude: 37.7880, longitude: -122.3995)]
        
        let currentLocation = CLLocationManager()
        
        //openInMap(locations: [location1, location2, location3, location4, location5, location6, location7, location8, location9, location10, location11, location12, location13, location14])
      
        deneme(locations:locations)
        super.viewDidLoad()
        
        currentLocation.delegate = self
    }
    
    func deneme(locations: [CLLocationCoordinate2D]){
  
        


        let locations = [CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                         CLLocationCoordinate2D(latitude: 37.8074, longitude: -122.2719),
                         CLLocationCoordinate2D(latitude: 37.7648, longitude: -122.4230),
                         CLLocationCoordinate2D(latitude: 37.7880, longitude: -122.3995)]

        let apiKey = "apiKey"
   
        let baseURL = "https://api.mapbox.com/optimized-trips/v1/mapbox/driving/"

        let coordinates = locations.map({ "\($0.longitude),\($0.latitude)" }).joined(separator: ";")
        let requestURL = "\(baseURL)\(coordinates)?access_token=\(apiKey)"

        let task = URLSession.shared.dataTask(with: URL(string: requestURL)!) { (data, response, error) in
            if let error = error {
                print("Error fetching optimized locations: \(error)")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Invalid response")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }

        task.resume()

    }
    
    func openInMap(locations: [CLLocationCoordinate2D]) {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        var currentLocation = CLLocation()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location!
        }
        
        var distances: [(location: CLLocationCoordinate2D, distance: CLLocationDistance)] = []
        for location in locations {// ilk durağı belirlemek için
            let distance = CLLocation(latitude: location.latitude, longitude: location.longitude).distance(from: currentLocation)
            distances.append((location: location, distance: distance))
        }
        
        distances.sort(by: { $0.distance < $1.distance })
        
        var mapItems: [MKMapItem] = []
        var visitedLocations: [CLLocationCoordinate2D] = []
        visitedLocations.append(distances[0].location)
        
        while visitedLocations.count != locations.count {// ilk duraktan sonraki durakları belirlemek için
            var closestLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            var closestDistance = Double.greatestFiniteMagnitude
            
            for (location, _) in distances where !visitedLocations.contains(where: { $0 == location }) {
                let lastVisitedLocation = visitedLocations[visitedLocations.count - 1]
                let currentDistance = CLLocation(latitude: location.latitude, longitude: location.longitude).distance(from: CLLocation(latitude: lastVisitedLocation.latitude, longitude: lastVisitedLocation.longitude))
                
                if currentDistance < closestDistance {
                    closestLocation = location
                    closestDistance = currentDistance
                }
            }
            
            visitedLocations.append(closestLocation)
        }
        
        let addKonum = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        visitedLocations.insert(addKonum, at: 0)// yol tarifinin kullanıcının konumunda başlaması için ekledik
        
        for location in visitedLocations {
            let destinationPlaceMark = MKPlacemark(coordinate: location, addressDictionary: nil)
            let destinationItem = MKMapItem(placemark: destinationPlaceMark)
            mapItems.append(destinationItem)
        }
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
    }

}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
