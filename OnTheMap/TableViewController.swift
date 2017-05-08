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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        studentListTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(StudentInformationArray.count)
        return StudentInformationArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        
        let singleCell = StudentInformationArray[indexPath.row]
        
        
        cell.textLabel?.text =  "\( singleCell.firstName )"  +  "\( singleCell.lastName )"
        cell.detailTextLabel?.text = "\(singleCell.mediaURL)"
        
        return cell
    }
    //delete on swipe
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            StudentInformationArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
        let app = UIApplication.shared
        let goToWeb = StudentInformationArray[indexPath.row].mediaURL
            app.open(URL(string: goToWeb)!)
        
        
    }
    
    
//    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
//        
//        detailController.imageFromCollection = true
//        detailController.meme = appDelegate.memes2[indexPath.row]
//        
//        self.navigationController!.pushViewController(detailController, animated: true)
//    }
}
