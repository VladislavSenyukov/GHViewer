//
//  ViewController.swift
//  GH Viewer
//
//  Created by ruckef on 03.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

import UIKit

class GHUsersViewController: UIViewController, GHPageCollectionDelegate, UITableViewDelegate, UITableViewDataSource {

    var url: String?
    var collection: GHGitUserPageCollection? {
        didSet {
            if collection != nil {
                collection?.delegate = self
            }
        }
    }
    
    @IBOutlet var tableView: UITableView?
    @IBOutlet var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if url != nil {
            collection = GHGitUserPageCollection(url: url!)
            spinner?.startAnimating()
        }
    }

    func pageCollectionDidLoadPage() {
        tableView?.reloadData()
        spinner?.stopAnimating()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collection != nil {
            return collection!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(GHUserTableViewCell.identifier) as? GHUserTableViewCell {
            let user = collection![indexPath.row]
            cell.user = user.cellData
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = collection![indexPath.row]
        let title = user.login
        let url = user.followersUrl
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextVC = storyboard.instantiateViewControllerWithIdentifier("GHUsersViewController") as! GHUsersViewController
        nextVC.title = title
        nextVC.url = url
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

