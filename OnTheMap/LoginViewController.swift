//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectionStatus: UIView!
    
    //check for an open connection to the internet
    var reachability: OTMap_NetworkReachability? = OTMap_NetworkReachability.networkReachabilityForInternetConnection()
    
    //NOTE: signup button is implemented as a triggered segue action in storyBoard
    @IBOutlet weak var userAccountTextField: UITextField!
    @IBOutlet weak var userPwdTextField: UITextField!
    
    var isDeviceVertical = true
    var emailAccountText: String? = nil
    var userPwdText: String? = nil

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginActivityIndicator.isHidden = true
        setUpTextField()

        checkReachability()
                 //set notificationCenter for changes in network state
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        _ = reachability?.startNotifier()
    }

       internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.verticalSizeClass == .compact {
            isDeviceVertical = false
        }
        else {
            isDeviceVertical = true
        }
    }

    private func setUpTextField(){
        userAccountTextField.delegate = self
        userPwdTextField.delegate = self
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
            
            OTMap_Tasks().performUpdatesOnMainQueue {
                
                if success {
                    self.loginActivityIndicator.isHidden = true
                    self.loginActivityIndicator.stopAnimating()
                    self.completeLogin()
                } else {
                    self.loginActivityIndicator.isHidden = true
                    self.loginActivityIndicator.stopAnimating()

                    
                    //MARK: failed login alert
                    let actionSheet = UIAlertController(title: "ERROR", message: errorString?.localizedDescription, preferredStyle: .alert)
                    
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(actionSheet,animated: true, completion: nil)
                }
            }
        }
        loginActivityIndicator.isHidden = false
        loginActivityIndicator.startAnimating()
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
    
    private func subscribeToKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications(){
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    internal func keyboardWillShow(_ notification: Notification){
      
        let heightVar = !isDeviceVertical ? CGFloat(10.0) : CGFloat(0.0)
        if isDeviceVertical == false {
            view.frame.origin.y = heightVar - getKeyboardHeight(notification)
        }
    }
    
    //return frame to original position
    internal func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification: Notification)-> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: - delegate methods
    
    internal func textFieldDidBeginEditing(_ : UITextField) {
        //allow image push when typing in textField
        subscribeToKeyboardNotifications()
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        
        //remove form notification after editing textField
        unsubscribeFromKeyboardNotifications()
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
