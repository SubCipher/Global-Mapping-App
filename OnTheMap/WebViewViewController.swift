//
//  WebViewViewController.swift
//  OnTheMap
//
//  Created by knax on 5/11/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {
    
    var urlRequest: URLRequest? = nil
   
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
    
    @IBOutlet weak var udacityWebview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            let udacityURL = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")
            let udacityURLRequest = URLRequest(url: udacityURL!)
            
          
            udacityWebview.loadRequest(udacityURLRequest)

        
            }
    
    
    @IBAction func cancelLogin(_ sender: UIBarButtonItem) {
       self.dismiss(animated: true, completion: nil) 
    }
    
    

    
}
