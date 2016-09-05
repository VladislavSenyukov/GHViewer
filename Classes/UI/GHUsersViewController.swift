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
    var followers = false
    
    @IBOutlet var tableView: UITableView?
    @IBOutlet var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if url != nil {
            collection = GHGitUserPageCollection(url: url!, offsetById: !followers)
            spinner?.startAnimating()
        }
    }

    func pageCollectionDidLoadPage() {
        let count = collection!.count
        let lastLoadedCount = collection!.lastLoadedCount
        if lastLoadedCount > 0 {
            var indexPaths = [NSIndexPath]()
            for i in count-lastLoadedCount..<count {
                indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
            }
            tableView?.beginUpdates()
            tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
            tableView?.endUpdates()
        }
        spinner?.stopAnimating()
    }
    
    func pageCollectionDidFail(error: NSError) {
        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
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
        nextVC.followers = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == collection!.count-1 {
            spinner?.startAnimating()
            collection?.load()
        }
    }
    
}