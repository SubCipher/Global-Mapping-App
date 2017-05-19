//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by knax on 5/8/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBAction func logoutBarItem(_ sender: UIBarButtonItem) {
        
        OTMap_Tasks().udacityLogoutMethod() {(success, errorString) in
            
            if success {
                performUpdatesOnMainQueue {
                    self.dismiss(animated: true, completion: nil)
                    }
            } else {
               
                let actionSheet = UIAlertController(title: "Error During Logout", message: errorString?.localizedDescription, preferredStyle: .alert)
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(actionSheet,animated: true,completion: nil)
            }
        }
        
    }
}
