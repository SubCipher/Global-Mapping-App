//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var connectionStatus: UIView!
    
    //check for an open connection to the internet
    var reachability: OTMap_NetworkReachability? = OTMap_NetworkReachability.networkReachabilityForInternetConnection()
    
    //NOTE: signup button is implemented as a triggered segue action in storyBoard
    @IBOutlet weak var userAccountTextField: UITextField!
    @IBOutlet weak var userPwdTextField: UITextField!
    
    var emailAccountText: String? = nil
    var userPwdText: String? = nil

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkReachability()
        
        //set notificationCenter for changes in network state
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        _ = reachability?.startNotifier()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide until empty fields flagged at login
        
    }
 
    //remove notificationCenter when class is deallocated
    //https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Deinitialization.html
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }
    
    @IBAction func udacityAuthLogin(_ sender: AnyObject) {
        udacityLogin()
    }
    
    func udacityLogin() {
        
        emailAccountText = userAccountTextField.text
        userPwdText = userPwdTextField.text
        
        OTMap_Tasks.sharedInstance().udacityPostForLogin(emailAccountText ?? "", userPwdText ?? "") { (success,errorString) in
            
            performUpdatesOnMainQueue {
                
                if success {
                    self.completeLogin()
                } else {
                    
                    //MARK: failed login alert
                    let actionSheet = UIAlertController(title: "ERROR", message: errorString?.localizedDescription, preferredStyle: .alert)
                    
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(actionSheet,animated: true, completion: nil)
                }
            }
        }
    }
    
    func completeLogin(){
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
}

extension LoginViewController {
    
    //MARK: - network reachability
    
    func checkReachability() {
        guard let networkState = reachability else { return }
        
        //this uses the "slim-line" view running along the lower half of main view to indicate network status
        //green = found connection / red = no connection
        
        if networkState.isReachable {
            
            connectionStatus.backgroundColor = UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        } else {
            connectionStatus.backgroundColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
            
            //MARK: failed connection alert
            let actionSheet = UIAlertController(title: "NETWORK ERROR", message: "Your Internet Connection Cannot Be Detected", preferredStyle: .alert)
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet,animated: true, completion: nil)
            
        }
    }
    
    
    func reachabilityDidChange(_ notification: Notification){
        checkReachability()
    }
}
