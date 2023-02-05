import MapKit
import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sourceLocation = CLLocationCoordinate2D(latitude: 41.033333, longitude: 28.850011)
        let destinationLocation = CLLocationCoordinate2D(latitude: 41.034755, longitude: 28.861355)
    
        createPath(sourceLocation: sourceLocation, destinationLocation: destinationLocation)
           
           self.mapView.delegate = self
       }

       func createPath(sourceLocation : CLLocationCoordinate2D, destinationLocation : CLLocationCoordinate2D) {
           let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)//istenilen konumu MKPlacemark nesnesine dönüştürdük
           let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
           let location3 = CLLocationCoordinate2D(latitude: 41.03, longitude: 28.89)
           let location4 = CLLocationCoordinate2D(latitude: 41.04, longitude: 28.86)
           
           let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)//MKPlacemark'ı  MKItem nesnesine dönüştürdük
           let destinationItem = MKMapItem(placemark: destinationPlaceMark)
           
           let location3Placemark = MKPlacemark(coordinate: location3, addressDictionary: nil)
           let location4Placemark = MKPlacemark(coordinate: location4, addressDictionary: nil)
           
           let location3Annotation = MKPointAnnotation()
           location3Annotation.coordinate = location3
           location3Annotation.title = "Location 3"
           location3Annotation.subtitle = "subtitle for location 3"

           let location4Annotation = MKPointAnnotation()
           location4Annotation.coordinate = location4
           location4Annotation.title = "Location 4"
           location4Annotation.subtitle = "subtitle for location 4"
           
           let sourceAnotation = MKPointAnnotation()//annotationların nasıl görüneceğini belirledik
           sourceAnotation.title = "Deneme1"
           sourceAnotation.subtitle = "örnek açıklama"
           if let location = sourcePlaceMark.location {
               sourceAnotation.coordinate = location.coordinate
           }
           
           let destinationAnotation = MKPointAnnotation()//annotationların nasıl görüneceğini belirledik
           
           destinationAnotation.title = "Deneme12"
           destinationAnotation.subtitle = "Örnek açıklama 1"
           if let location = destinationPlaceMark.location {
               destinationAnotation.coordinate = location.coordinate
           }
           
           self.mapView.showAnnotations([sourceAnotation, destinationAnotation, location3Annotation, location4Annotation], animated: true)
           
           
           
           let directionRequest = MKDirections.Request()//rota çizilmesi için istek oluşturacağız
           directionRequest.source = sourceMapItem
           directionRequest.destination = destinationItem
           directionRequest.transportType = .automobile
           
           let direction = MKDirections(request: directionRequest)
           
           
           direction.calculate { (response, error) in      // eğer hata yoksa çizilen rotamızı alıyoruz
               guard let response = response else {
                   if let error = error {
                       print("ERROR FOUND : \(error.localizedDescription)")
                   }
                   return
               }
               
               
               let route = response.routes[0]
               for step in route.steps {
                           print(step.instructions)
                       }
                              self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                              
                              let rect = route.polyline.boundingMapRect
                              
                              self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
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
