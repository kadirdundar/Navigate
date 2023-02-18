import UIKit
import MapKit
import CoreLocation

class navigasyonVC: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        
        var locations: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 41.034610, longitude: 28.883511),
            CLLocationCoordinate2D(latitude: 41.019411, longitude: 28.914611),
            CLLocationCoordinate2D(latitude: 41.031211, longitude: 28.951211),
            CLLocationCoordinate2D(latitude: 41.030411, longitude: 28.892311),
            CLLocationCoordinate2D(latitude: 41.038111, longitude: 28.887611),
            CLLocationCoordinate2D(latitude: 41.041511, longitude: 28.932111)]

        
        let currentLocation = CLLocationManager()
        
        //openInMap(locations: [location1, location2, location3, location4, location5, location6, location7, location8, location9, location10, location11, location12, location13, location14])
      
        super.viewDidLoad()
        deneme(locations: locations) { locations in
            if let locations = locations{
                print(locations)
                print("basarıli")//basarili
            }
        }
        currentLocation.delegate = self
    }
    
    func addFirstAndLastLocation(locations: [CLLocationCoordinate2D])-> (first: CLLocationCoordinate2D, last: CLLocationCoordinate2D)? {
        
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
        let firstElement = distances[0].location
        let lastElement = distances[distances.count - 1].location
        print(distances)
      
        return (firstElement, lastElement)
    }

    func deneme(locations: [CLLocationCoordinate2D], completion : @escaping([CLLocationCoordinate2D]?)->())-> ([CLLocationCoordinate2D]){//konumları sıralamak için istek
        var locationList: [[Double]] = []
        var newList = [CLLocationCoordinate2D]()
        
        let element = addFirstAndLastLocation(locations: locations)
        for loc in locations{
            if loc != element?.first && loc != element?.last{
                newList.append(loc)
                
            }
        }
        print(newList)
        print("012012010201010210010101001011")
        if let firstElement = element?.first {
            newList.insert(firstElement, at: 0)
        }

        // Set the last element of newList to element.last
        if let lastElement = element?.last {
            newList.append(lastElement)
        }
        print(newList)
        print("222222222222222222222")
        
        let apiKey = "*"
   
        let baseURL = "https://api.mapbox.com/optimized-trips/v1/mapbox/driving/"
    
        // Rota üzerindeki duraklar
        let coordinates = newList.map({ "\($0.longitude),\($0.latitude)" }).joined(separator: ";")
        print(coordinates)
        print("3333333333333333333")
        // API isteği için URL oluşturma
        let params = "source=first&destination=last&roundtrip=false"

      
        let requestURL = "\(baseURL)\(coordinates)?\(params)&access_token=\(apiKey)"
        let task = URLSession.shared.dataTask(with: URL(string: requestURL)!) { (data, response, error) in
            if let error = error {
                print("Error fetching optimized locations: \(error)")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Invalid response")
                
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            
            if let waypoints = json?["waypoints"] as? [[String: Any]] {
                
                var waypointDictionary = [Int: [String: Any]]()

                for waypoint in waypoints {
                    let index = waypoint["waypoint_index"] as! Int
                    let location = waypoint["location"] as! [Double]
                    waypointDictionary[index] = ["location": location]
                }
                print(waypointDictionary)
                print("*****************")
                

                let sortedKeys = waypointDictionary.keys.sorted()
                for key in sortedKeys {
                    let location = waypointDictionary[key]!["location"]!
                    locationList.append(location as! [Double])
                }

                print(locationList)
                newList.removeAll()
                for loc in locationList{
                    let element = CLLocationCoordinate2D(latitude: loc[1], longitude: loc[0])
                    newList.append(element)
                    
                }
                        
                
                
                    completion(newList)
                } else {
                    completion(nil)
                }
        }
        task.resume()
     
        return newList
    }
    
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
func forDecision(locations : [CLLocationCoordinate2D]){
    if locations.count >= 12{
        
    }
    
}
