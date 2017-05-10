//
//  MapKitViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTMap_Tasks.sharedInstance().loadStudentLocations(completionHandlerForLocations: { (success,errorString) in
            
            if success {
                
            performUpdatesOnMainQueue {
                
                    var annotations = [MKPointAnnotation]()
                    
                    for student in StudentInformationArray {
                        
                        let lat = CLLocationDegrees(student.latitude)
                        let long = CLLocationDegrees(student.longitude )
                        
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let first = student.firstName
                        let last = student.lastName
                        let medidaURL = student.mediaURL
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = medidaURL
                        
                        if annotations .contains(annotation) {
                            print("already added")
                        } else {
                            annotations.append(annotation)

                        }
                                           }
                    self.mapView.addAnnotations(annotations)
                }

            } else {
                
                let actionSheet = UIAlertController(title: "Error Downloading", message: errorString?.localizedDescription, preferredStyle: .alert)
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(actionSheet,animated: true,completion: nil)
            }
        })
    }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

    }
    
    //MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .green
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

