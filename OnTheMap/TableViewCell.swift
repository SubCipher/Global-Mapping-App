//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by knax on 5/18/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var webSiteLinks: UILabel!
    
    var studentLocation: StudentDataSource.StudentInformation? {  didSet {updateUI() }}
    //update pin annotation
    private func updateUI() {
        studentNameLabel?.text = "\(studentLocation?.firstName ?? "")" + "\(studentLocation?.lastName ?? "")"
        webSiteLinks?.text = studentLocation?.mediaURL ?? ""
    }
}
