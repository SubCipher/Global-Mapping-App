//
//  PostViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PostViewController: UIViewController, UITextFieldDelegate  {
    
    //geocode implementation reference https://cocoacasts.com/forward-and-reverse-geocoding-with-clgeocoder-part-1/
    
    @IBOutlet weak var miniMapKitView: MKMapView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var mediaURL: UITextField!
    
    @IBOutlet weak var postLocationButton: UIButton!
    @IBOutlet weak var geocodeButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var locationLabel: UILabel!
    
    lazy var geocoder = CLGeocoder()
    var sendToPost: StudentDataSource.postUserInfo? = nil    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegation()
        activityIndicatorView.isHidden = true
        postLocationButton.isHidden = true
    }

    func textFieldDelegation(){
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        streetTextField.delegate = self
        cityTextField.delegate = self
        countryTextField.delegate = self
        mediaURL.delegate = self
    }
    
    @IBAction func geocodeAction(_ sender: UIButton) {
        self.geocodeButton.isHidden = true
        self.activityIndicatorView.isHidden = false
        self.activityIndicatorView.startAnimating()
        
        guard let country = countryTextField.text else {return}
        guard let street = streetTextField.text else {return}
        guard let city = cityTextField.text else {return}
        
        let locationString = "\(country) " + "\(city) " +  "\(street)"
        
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            
            self.activityIndicatorView.isHidden = true
            self.geocodeButton.isHidden = false
            self.activityIndicatorView.stopAnimating()
            
            if error != nil {
                
                let actionSheet = UIAlertController(title: "ERROR", message: "could not get address, pls check your entry", preferredStyle: .alert)
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(actionSheet,animated: true, completion: nil)
                
            } else {
                
                var location: CLLocation?
                if (self.firstNameTextField.text?.isEmpty)! || (self.mediaURL.text?.isEmpty)! {
                    
                    let actionSheet = UIAlertController(title: "ERROR", message: "Missing Name or Website", preferredStyle: .alert)
                    
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(actionSheet,animated: true, completion: nil)
                }
                else {
                
                    let firstName = self.firstNameTextField.text!
                    let lastName = self.lastNameTextField.text!
                    let mapString = self.streetTextField.text!
                    let mediaURL = self.mediaURL.text!
                    
                    if let placemarks = placemarks  {
                        //if multiple results choose the first one
                        location = placemarks.first?.location
                        let coordinate = location?.coordinate
                        
                        let distanceSpan: CLLocationDegrees = 1000
                        let locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake((coordinate?.latitude)!, (coordinate?.longitude)!)
                        
                        self.miniMapKitView.setRegion(MKCoordinateRegionMakeWithDistance(locationCoordinate, distanceSpan, distanceSpan), animated: true)
                        
                        let locationPin = OTMap_Annotation(title: "\(firstName) \(lastName)", subtitle: "\(mediaURL)", coordinate: coordinate!)
                        self.miniMapKitView.addAnnotation(locationPin)
                        
                        
                        let newLocationDictionary:[String:AnyObject] = ["firstName":firstName as AnyObject,
                                                                        "lastName" :lastName as AnyObject,
                                                                        "mediaURL": mediaURL as AnyObject,
                                                                        "mapString": mapString as AnyObject,
                                                                        "uniqueKey": StudentDataSource.sharedInstance.UniqueKey as AnyObject,
                                                                        "latitude":locationCoordinate.latitude as AnyObject,
                                                                        "longitude":locationCoordinate.longitude as AnyObject]
                        
                        self.sendToPost = StudentDataSource.postUserInfo(newLocationDictionary)
                        self.postLocationButton.isHidden = false
                   }
                }
            }
        }
    }
    @IBAction func postLocation(_ sender: UIButton) {
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        OTMap_Tasks().postNewLocation(sendToPost!) {(success,error) in
            
            self.activityIndicatorView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            
            OTMap_Tasks().performUpdatesOnMainQueue {
                
                if success == false{
                    
                    let actionSheet = UIAlertController(title: "ERROR", message: "record update failed to post", preferredStyle: .alert)
                    
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(actionSheet,animated: true, completion: nil)
                    
                } else {
                    
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController")
                    self.present(controller, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    @IBAction func cancelPost(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func subscribeToKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldShouldReturn(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications(){
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}


