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
   
    //option to check for single host: => var reachability = OTMap_NetworkReachability(hostName: "https://udacity.com")
    //check for an open connection to the internet
    var reachability: OTMap_NetworkReachability? = OTMap_NetworkReachability.networkReachabilityForInternetConnection()
    //NOTE: signup button is implemented as a triggered segue action in storyBoard
    @IBOutlet weak var userAccountTextField: UITextField!
    @IBOutlet weak var userPwdTextField: UITextField!
    
    @IBOutlet weak var missingUserAccountLabel: UILabel!
    @IBOutlet weak var missingPwdLabel: UILabel!
    
    var emailAccountText: String? = nil
    var userPwdText: String? = nil
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //check network reachability
        checkReachability()
        
        //set notificationCenter for changes in network state
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        _ = reachability?.startNotifier()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide lables; not needed until empty fields flagged at login
        missingUserAccountLabel.isHidden = true
        missingPwdLabel.isHidden = true
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
        
        emailAccountText = "krishna.picart@kpicart.com"
        userPwdText = "password4OTM"
        //emailAccountText = userAccountTextField.text
        //userPwdText = userPwdTextField.text
        
        OTMap_Tasks.sharedInstance().udacityPostForLogin(emailAccountText ?? "", userPwdText ?? "") { (success,errorString) in
           //add action to main queue
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
        
        if networkState.isReachable {
            //this is the mini-view on lower left of main view used to indicate network status: green = found connection / red = no connection
            connectionStatus.backgroundColor = UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
            } else {
            //change background color to light red to indicate connection failure
            connectionStatus.backgroundColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
            //MARK: failed connection alert
            let actionSheet = UIAlertController(title: "NETWORK ERROR", message: "Your Internet Connection Cannot Be Detected", preferredStyle: .alert)
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet,animated: true, completion: nil)
            
            print("no network connection found")
        }
    }
    
    
    func reachabilityDidChange(_ notification: Notification){
        checkReachability()
    }
}




