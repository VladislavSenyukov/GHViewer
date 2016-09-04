//
//  GHUserTableViewCell.swift
//  GH Viewer
//
//  Created by ruckef on 05.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

import AFNetworking

protocol GHIdentifiable {
    static var identifier: String {get}
}

struct GHUserCellData {
    let login: String
    let profileUrl: String
    let pictureUrl: String
}

class GHUserTableViewCell: UITableViewCell, GHIdentifiable {
    static var identifier: String {
        return "GHUserTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }
    
    @IBOutlet var loginLabel: UILabel?
    @IBOutlet var profileUrlLabel: UILabel?
    @IBOutlet var profileImageView: UIImageView?
    
    var user: GHUserCellData? {
        didSet {
            if let aUser = user {
                contentView.backgroundColor = UIColor.rand()
                loginLabel?.text = aUser.login
                profileUrlLabel?.text = aUser.profileUrl
                profileImageView?.setImageWithURL(NSURL(string: aUser.pictureUrl)!)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let side = profileImageView!.frame.width/2.0
        profileImageView?.layer.cornerRadius = side
        profileImageView?.layer.shouldRasterize = true
        profileImageView?.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
}

extension UIColor {
    static func rand() -> UIColor {
        let colorConst = UInt32(255)
        let r = arc4random()%colorConst
        let g = arc4random()%colorConst
        let b = arc4random()%colorConst
        let color = UIColor(red: CGFloat(r)/CGFloat(colorConst), green: CGFloat(g)/CGFloat(colorConst), blue: CGFloat(b)/CGFloat(colorConst), alpha: 1)
        return color
    }
}