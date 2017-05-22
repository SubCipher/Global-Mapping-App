//
//  ShowStudentLocationViewController.swift
//  OnTheMap
//
//  Created by knax on 5/9/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit


class ShowStudentLocationViewController: UIViewController {
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitutde: UILabel!
    @IBOutlet weak var mapString: UILabel!
    @IBOutlet weak var mediaURL: UILabel!
    
    @IBOutlet weak var objectID:  UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var uniqueKey: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    var showStudentAtLocation: StudentDataSource.StudentInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objectID.text = showStudentAtLocation.objectId
        updatedAt.text = showStudentAtLocation.updatedAt
        uniqueKey.text = "\(showStudentAtLocation.uniqueKey)"
        createdAt.text = showStudentAtLocation.createdAt
        
        firstName.text = showStudentAtLocation.firstName
        lastName.text = showStudentAtLocation.lastName
        latitude.text = "\(showStudentAtLocation.latitude)"
        longitutde.text = "\(showStudentAtLocation.longitude)"
        mapString.text = showStudentAtLocation.mapString
        mediaURL.text = showStudentAtLocation.mediaURL
        
    }
}
