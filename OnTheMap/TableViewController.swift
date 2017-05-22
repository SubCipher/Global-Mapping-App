//
//  TableViewController.swift
//  OnTheMap
//
//  Created by knax on 4/23/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var studentListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentListTableView.estimatedRowHeight = studentListTableView.rowHeight
        studentListTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDataSource.sharedInstance.StudentData.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let singleCell = StudentDataSource.sharedInstance.StudentData[indexPath.row]
        
        if let customCell = cell as? TableViewCell {
            customCell.studentLocation = singleCell
        }
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let showViewController = self.storyboard!.instantiateViewController(withIdentifier: "UpdateStudentLocationViewController") as! ShowStudentLocationViewController
        showViewController.showStudentAtLocation = StudentDataSource.sharedInstance.StudentData[indexPath.row]
        self.navigationController!.pushViewController(showViewController, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            StudentDataSource.sharedInstance.StudentData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        let goToWeb = StudentDataSource.sharedInstance.StudentData[indexPath.row].mediaURL
        
        //use default website to prevent fail if no URL is assigned to location
        let defaultWebSite = (URL(string: "http://udacity.com")!)
        app.open(URL(string: goToWeb) ?? defaultWebSite)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
