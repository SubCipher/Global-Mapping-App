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
      
        udacityLogoutMethod() {(success, errorString) in
            if success {
                
                //StudentInformationArray.removeAll()
                self.dismiss(animated: true, completion: nil)
                
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(controller, animated: true, completion: nil)
                print("result of action =",success)
            } else {
                print("unexpected results: \(String(describing: errorString))  ")
            }
        }
        
    }

    
    
    func udacityLogoutMethod(completionHandlerForLogout: @escaping ( _ success:Bool, _ error: NSError?) ->Void) {
        
        print("logout in progress")
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandlerForLogout(false,NSError(domain: "SessionLogout", code: 1, userInfo: [NSLocalizedDescriptionKey: "Erorr while loging out"]))
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            completionHandlerForLogout(true,nil)
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
        

    }
    
}
