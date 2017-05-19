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
        
        let udacityURL = URL(string: OTMap_Tasks.Constants.SignUpURL)
        let udacityURLRequest = URLRequest(url: udacityURL!)
        
        udacityWebview.loadRequest(udacityURLRequest)
    }
    
    @IBAction func cancelLogin(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
