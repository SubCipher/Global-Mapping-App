//
//  ViewController.swift
//  OnTheMap
//
//  Created by knax on 4/22/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var parseStudentLocations = [[String:AnyObject]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
  
    
    
    @IBAction func ParseAuthGetFunc(_ sender: UIBarButtonItem) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        //the fully formed network request
        let request = NSMutableURLRequest(url: URL(string:urlString)!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        //active call to make the server
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                return
            }
            
        let parseJSONdata = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
            
            
            func parseAsDictionary( _ dictionary: NSDictionary) {
                guard let parsedDictionaries = parseJSONdata["results"] as? [[String:AnyObject]] else {
                    print("no can do")
                    return
                }
                //print("results =",parsedDictionaries)
                self.parseStudentLocations = parsedDictionaries
                print("results =",self.parseStudentLocations)
                
                
                
                var annotations = [MKPointAnnotation]()
                
                
                for dictionary in self.parseStudentLocations {
                    let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                    let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary["firstName"] as! String
                    let last = dictionary["lastName"] as! String
                    let medidaURL = dictionary["mediaURL"] as! String
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = medidaURL
                    
                    annotations.append(annotation)
                    
                }
                self.mapView.addAnnotations(annotations)
                print("annotations",annotations,annotations.count)
                
                


            }
            
            parseAsDictionary(parseJSONdata)
        
        }
        
        task.resume()
        
       
    }
    
    
    
    
    
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
    
}

