//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by knax on 5/8/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logoutBarItem(_ sender: UIBarButtonItem) {
     
         OTMap_Tasks().udacityLogoutMethod() {(success, errorString) in
            if success {
                
                self.dismiss(animated: true, completion: nil)
                //works without this but VC is slow to dismiss and slow to present new
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(controller, animated: true, completion: nil)
                
            } else {
                
                let actionSheet = UIAlertController(title: "Error During Logout", message: errorString?.localizedDescription, preferredStyle: .alert)
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(actionSheet,animated: true,completion: nil)

            }
        }
        
    }

    
    
       
}
