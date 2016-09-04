//
//  GHUser.swift
//  GH Viewer
//
//  Created by ruckef on 03.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

class GHUser: GHUniqueObject {
    let login: String
    let profileUrl : String
    let profilePictureUrl : String
    let followersUrl: String
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let login = jsonDic[GHKeys.login.string] as? String,
            let profileUrl = jsonDic[GHKeys.url.string] as? String,
            let profilePictureUrl = jsonDic[GHKeys.avatar_url.string] as? String,
            let followersUrl = jsonDic[GHKeys.followers_url.string] as? String
        else {
            return nil
        }
        self.login = login
        self.profileUrl = profileUrl
        self.profilePictureUrl = profilePictureUrl
        self.followersUrl = followersUrl
        super.init(jsonDic: jsonDic)
    }
}
