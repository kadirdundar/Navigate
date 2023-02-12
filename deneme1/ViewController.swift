import MapKit
import UIKit
import CoreLocation


class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locations: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 41.0346, longitude: 28.8835),
            CLLocationCoordinate2D(latitude: 41.0194, longitude: 28.9146),
            CLLocationCoordinate2D(latitude: 41.0312, longitude: 28.9512),
            CLLocationCoordinate2D(latitude: 41.0304, longitude: 28.8923),
            CLLocationCoordinate2D(latitude: 41.0381, longitude: 28.8876),
            CLLocationCoordinate2D(latitude: 41.0415, longitude: 28.9321),
            CLLocationCoordinate2D(latitude: 41.0202, longitude: 28.9042),
            CLLocationCoordinate2D(latitude: 41.0371, longitude: 28.9195),
            CLLocationCoordinate2D(latitude: 41.0142, longitude: 28.8946),
            CLLocationCoordinate2D(latitude: 41.0356, longitude: 28.9076),
            CLLocationCoordinate2D(latitude: 41.0448, longitude: 28.8822),
            CLLocationCoordinate2D(latitude: 41.0288, longitude: 28.9286),
            CLLocationCoordinate2D(latitude: 41.0208, longitude: 28.9492),
            CLLocationCoordinate2D(latitude: 41.0123, longitude: 28.8911),
            CLLocationCoordinate2D(latitude: 41.0381, longitude: 28.9213),
            CLLocationCoordinate2D(latitude: 41.0444, longitude: 28.9086),
            CLLocationCoordinate2D(latitude: 41.0269, longitude: 28.9144),
            CLLocationCoordinate2D(latitude: 41.0333, longitude: 28.8865),
            CLLocationCoordinate2D(latitude: 41.0392, longitude: 28.9321)
        ]

    
        createPaths(locations: locations)
           
           self.mapView.delegate = self
       }
    func orderLocation(locations: [CLLocationCoordinate2D])->[CLLocationCoordinate2D]{
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
        return visitedLocations
    }
    func createPaths(locations: [CLLocationCoordinate2D]) {
        
      let newLocations = orderLocation(locations: locations)
      for i in 0..<newLocations.count-1 {
        let sourceLocation = newLocations[i]
        let destinationLocation = newLocations[i+1]

        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile


        let direction = MKDirections(request: directionRequest)

        direction.calculate { (response, error) in
          guard let response = response else {
            if let error = error {
              print("ERROR FOUND : \(error.localizedDescription)")
            }
            return
          }

          let route = response.routes[0]
          self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            for (index, location) in newLocations.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = "Durak \(index + 1)"
                annotation.subtitle = "Durak açıklaması"
                self.mapView.addAnnotation(annotation)
            }

        }
      }
        
    }


   }

   extension ViewController : MKMapViewDelegate {
       func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           let rendere = MKPolylineRenderer(overlay: overlay)
           rendere.lineWidth = 5
           rendere.strokeColor = .systemBlue
           
           return rendere
       }
   }
