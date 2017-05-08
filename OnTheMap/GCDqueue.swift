//
//  GCDqueue.swift
//  OnTheMap
//
//  Created by knax on 4/25/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import Foundation

func performUpdatesOnMainQueue(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
