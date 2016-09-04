//
//  ViewController.swift
//  GH Viewer
//
//  Created by ruckef on 03.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

import UIKit

class GHUsersViewController: UIViewController, GHPageCollectionDelegate {

    let collection = GHGitUserPageCollection(url: "https://api.github.com/users")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collection.delegate = self
    }

    func pageCollectionDidLoadPage() {
        print(collection.objects.count)
        collection.load()
    }
    
}

