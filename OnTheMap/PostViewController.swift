//
//  PostViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit
import CoreLocation

class PostViewController: UIViewController {
    
    //geocode implementation based on tutorial from https://cocoacasts.com/forward-and-reverse-geocoding-with-clgeocoder-part-1/
    
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var mediaURL: UITextField!
    
    @IBOutlet weak var geocodeButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var locationLabel: UILabel!
    
    lazy var geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.isHidden = true
    }

    @IBAction func geocodeAction(_ sender: UIButton) {
        
        guard let country = countryTextField.text else {return}
        guard let street = streetTextField.text else {return}
        guard let city = cityTextField.text else {return}
        
        
        let address = "\(country) " + "\(city) " +  "\(street)"
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            
            self.activityIndicatorView.isHidden = true
            self.postNewGeocodeLocation(address, withPlacemarks: placemarks,error: error)
            }
        
        geocodeButton.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    //MARK- POST newLocation
    
    private func postNewGeocodeLocation(_ address: String, withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        geocodeButton.isHidden = false
        activityIndicatorView.stopAnimating()
        
        if error != nil {
            
            let actionSheet = UIAlertController(title: "ERROR", message: "could not get address, pls check your entry", preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet,animated: true, completion: nil)

            locationLabel.text = "no address found"
            //return
        } else {
            var location: CLLocation?
            //do some prep
            if let placemarks = placemarks  {
                //if multiple results choose the first one
                location = placemarks.first?.location
                let coordinate = location?.coordinate
                
                let mediaURLText = mediaURL.text
                //display coordinates on view screen
                locationLabel.text = "\(coordinate!.latitude) " + "\(coordinate!.longitude)"
                
                OTMap_Tasks().postNewLocation(mediaURLText ?? "http://udacity.com",coordinate!,address) {(success,error) in
                
                performUpdatesOnMainQueue {
                
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
    }
}

    @IBAction func cancelPost(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        }
}

