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
            self.submitGeocodeResponse(address, withPlacemarks: placemarks,error: error)
        }
        geocodeButton.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func submitGeocodeResponse(_ address: String, withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        geocodeButton.isHidden = false
        activityIndicatorView.stopAnimating()
        
        if error != nil {
            print("error obtaining geocode")
            locationLabel.text = "no address found"
            return
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks  {
                location = placemarks.first?.location
                let coordinate = location?.coordinate
                let mediaURLText = mediaURL.text
                locationLabel.text = "\(coordinate!.latitude) " + "\(coordinate!.longitude)"
                print(locationLabel.text!)
                OTMap_Tasks.sharedInstance().postNewLocation(mediaURLText ?? "http://udacity.com",coordinate!,address) {(success,error) in
                    
                }
            }
        }
    }

    @IBAction func cancelPost(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        }
}

