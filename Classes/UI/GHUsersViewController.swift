//
//  ViewController.swift
//  GH Viewer
//
//  Created by ruckef on 03.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

import UIKit

class GHUsersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let collection = GHPageCollection<GHUser>()
    }

}

