//
//  HomeViewController.swift
//  finalproject
//
//  Created by caro on 2022-04-05.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class ExploreViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    var locationsList : [Int] = []
    var shelterId:Int = 1
    // var animals:[AnimalResponse] = []
    var animalsDic:[Int:[AnimalResponse]] = [:]
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
        var currentLocationPin = "You are here!"

        //MARK:- ViewController LifeCycle Methods

        override func viewDidLoad() {
            super.viewDidLoad()
            setMap()
            
        }

        override func viewDidAppear(_ animated: Bool) {
            findCurrentLocation()
            getSheltor()
        }

        //MARK:- CLLocationManagerDelegate Methods
    private func setMap(){
        // set delegate
        mapView.delegate = self
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let newRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(newRegion, animated: true)

        // Get user's Current Location and Drop a pin
    let newAnnotation: MKPointAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        newAnnotation.title = self.setUsersClosestLocation(mLattitude: userLocation.coordinate.latitude, mLongitude: userLocation.coordinate.longitude)
        mapView.addAnnotation(newAnnotation)
    }
    //MARK:- Intance Methods

    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)

        return currentLocationPin
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
        }
    //MARK:- Intance Methods

    func findCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func getSheltor(){
        let ref = Database.database().reference()
        ref.child("location").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                print(child.value!)
                guard let data = try? JSONSerialization.data(withJSONObject: child.value!) else{
                    print("get Json Data failed")
                    return
                }
                guard let location = self.parseJson(data: data) else{
                    print("parseJson Location failed")
                    return
                }
                // print("in get sheltor: localtion:\(location)")
                let lat = location.latlng.lat
                let lng = location.latlng.lng
                let name = location.name
                let id = location.id
                self.addAnnotation(id:id,title: name, lat: lat, lng: lng)
                self.locationsList.append(id)
                print("in get sheltor: localtionList:\( self.locationsList)")
            }
            
            self.getAnimalsDic()
            
        })
        
    }
    
    private func parseJson(data:Data)->LocationResponse?{
        let decoder = JSONDecoder()
        var locationResponse: LocationResponse?

        do{
            locationResponse = try decoder.decode(LocationResponse.self, from: data)
        }catch{
            print("Error parsing location")
            print(error)
        }
        return locationResponse
    }
    
    private func addAnnotation(id:Int,title:String,lat:Float,lng:Float){
        let annotation = MyAnnotation(id:id,title:title,lat:lat,lng:lng)
        mapView.addAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myIdentifier"
        var view:MKMarkerAnnotationView
        
        // check to see if we have a view we can reuse
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            // get updated annotation
            dequeuedView.annotation = annotation
            view = dequeuedView
        }else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            if let annotation = view.annotation as? MyAnnotation {
                view.canShowCallout = true
                
                // set the position of the callout
                view.calloutOffset = CGPoint(x: 0, y: 10)
                
                // add a button to right side of callout
                let button = UIButton(type: .contactAdd)
                view.rightCalloutAccessoryView = button
                
                // add an image to left side of callout
                let image = UIImage(systemName: "heart.circle")
                view.leftCalloutAccessoryView = UIImageView(image:image)
            }

        }
        return view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToCard") {
            let vc = segue.destination as! CardViewController
            guard let animals = animalsDic[shelterId] else{
                return
            }
            vc.animals = animals
            
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Button Click1")
        
        if let annotation = view.annotation as? MyAnnotation {
            self.shelterId = annotation.id
            let cardSegue:String = "goToCard"
            self.performSegue(withIdentifier: cardSegue, sender: self)
  
        }
 
        //let newController = CardViewController()
        //self.present(newController, animated: true,completion: nil)
//        guard let coordinates = view.annotation?.coordinate else{
//            return
//        }
//        let launchOptions = [
//            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
//        ]
//
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
//        mapItem.openInMaps(launchOptions: launchOptions)
        
        
//        if let annotation = view.annotation as? MyAnnotation {
//            let id = annotation.id
//            let vc = UIViewController()
//            vc.view.backgroundColor = .cyan
//            navigationController?.pushViewController(vc, animated: true)
//
//        }
//        else{
//            print("Button Click")
//        }
    }
    
    private func initAnimals(id:Int){
        var animalList:[AnimalResponse] = []
        let ref = Database.database().reference()
        ref.child("animal/\(id)").observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                print(child.value!)
                guard let data = try? JSONSerialization.data(withJSONObject: child.value!) else{
                    print("get Json Data failed")
                    return
                }
                guard let animal = self.parseAnimalJson(data: data) else{
                    print("parseJson Animal failed")
                    return
                }
                animalList.append(animal)
               // print("in loadFromFirebase animalList1:\(animalList)")
            }
            
            self.animalsDic[id] = animalList
            // print("in loadFromFirebase animalList: \(String(describing: self.animalsDic[id]))")
        })
    }
    
    
    private func parseAnimalJson(data:Data)->AnimalResponse?{
        let decoder = JSONDecoder()
        var animalResponse: AnimalResponse?

        do{
            animalResponse = try decoder.decode(AnimalResponse.self, from: data)
        }catch{
            print("Error parsing location")
            print(error)
        }
        return animalResponse
    }
    
    private func getAnimalsDic(){
        for shelterId in locationsList{
            // print("in getAnimals Dis shelterID: \(shelterId)")
            initAnimals(id: shelterId)
            
        }
    }
}

class MyAnnotation: NSObject, MKAnnotation{
    let id:Int
    var coordinate:CLLocationCoordinate2D
    var title: String?
    
    init(id:Int,title:String,lat:Float,lng:Float){
        self.title = title
        self.id = id
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
    }
}

struct LocationResponse:Decodable{
    let id:Int
    let city:String
    let latlng:LatLng
    let name:String
}
struct LatLng:Decodable{
    let lat:Float
    let lng: Float
}

struct AnimalResponse:Decodable{
    let id:Int
    let shelterId:Int
    let name:String
    let type:String
    let age:Int
    let gender:String
    let description:String
    let image:String
}

