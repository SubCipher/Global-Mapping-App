//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var reachability = OTMap_NetworkReachability(hostName: "https://udacity.com")
    //var reachability: OTMap_NetworkReachability? = OTMap_NetworkReachability.networkReachabilityForInternetConnection()
    
    @IBOutlet weak var userAccountTextField: UITextField!
    @IBOutlet weak var userPwdTextField: UITextField!
    
    @IBOutlet weak var missingUserAccountLabel: UILabel!
    @IBOutlet weak var missingPwdLabel: UILabel!
    
    var emailAccountText: String? = nil
    var userPwdText: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide lables until user submits empty fields at login
        missingUserAccountLabel.isHidden = true
        missingPwdLabel.isHidden = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }
    
    @IBAction func udacityAuthLogin(_ sender: AnyObject) {
        /*
         NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
         _ = reachability?.startNotifier()
         
         */
        checkReachability()
    }
    
    func udacityLogin() {
        
        emailAccountText = "krishna.picart@kpicart.com"
        userPwdText = "password4OTM"
        //emailAccountText = userAccountTextField.text
        //userPwdText = userPwdTextField.text
        
        
        OTMap_Tasks.sharedInstance().udacityAuthLogin(emailAccountText ?? "", userPwdText ?? "") { (success,errorString) in
            performUpdatesOnMainQueue {
                if success {
                    self.completeLogin()
                } else {
                    if self.presentedViewController != nil {
                        //surpress warning message in console
                        return
                    }
                    else {
                        let actionSheet = UIAlertController(title: "ERROR", message: errorString?.localizedDescription, preferredStyle: .alert)
                        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(actionSheet,animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func completeLogin(){
        let controller = storyboard!.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    //direct user to a signUP screen
    @IBAction func signUP(_ sender: UIButton) {
        
    }
}

extension LoginViewController {
    
    //network reachability
    
    func checkReachability() {
        guard let r = reachability else { return }
        
        if r.isReachable {
            //view.backgroundColor = UIColor.green
            udacityLogin()
        } else {
            //change background color to light red to indicate connection failure
            view.backgroundColor = UIColor.init(red: 5.0, green: 2.0, blue: 2.0, alpha: 0.4)
            
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




