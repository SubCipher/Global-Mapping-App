//
//  UpdateStudentLocationViewController.swift
//  OnTheMap
//
//  Created by knax on 5/9/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit



class UpdateStudentLocationViewController: UIViewController {
    
    
    @IBOutlet weak var objectID:  UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var uniqueKey: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitutde: UITextField!
    @IBOutlet weak var mapString: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    
    var updateStudentAtLocation: StudentInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(updateStudentAtLocation)
        
        objectID.text = updateStudentAtLocation.objectId
        updatedAt.text = updateStudentAtLocation.updatedAt
        uniqueKey.text = "\(updateStudentAtLocation.uniqueKey)"
        createdAt.text = updateStudentAtLocation.createdAt
        
        firstName.text = updateStudentAtLocation.firstName
        lastName.text = updateStudentAtLocation.lastName
        latitude.text = "\(updateStudentAtLocation.latitude)"
        longitutde.text = "\(updateStudentAtLocation.longitude)"
        mapString.text = updateStudentAtLocation.mapString
        mediaURL.text = updateStudentAtLocation.mediaURL
        
        
        print("printed value = ",objectID.text ?? "")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateLocationRecord(_ sender: UIButton) {
      
        
    }
   }


