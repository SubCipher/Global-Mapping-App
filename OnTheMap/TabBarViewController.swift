//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by knax on 5/8/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //override default back nav button Item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(self.presentViewAtLogout))
    }
    
    func presentViewAtLogout() {
        
        OTMap_Tasks().udacityLogoutMethod() {(success, errorString) in
            
            if success {
                OTMap_Tasks().performUpdatesOnMainQueue {
                    
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(controller, animated: true, completion: nil)
                }
            } else {
                let actionSheet = UIAlertController(title: "Error During Logout", message: errorString?.localizedDescription, preferredStyle: .alert)
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(actionSheet,animated: true,completion: nil)
            }
        }
    }
}
