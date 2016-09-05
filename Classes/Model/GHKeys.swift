//
//  GHKeys.swift
//  GH Viewer
//
//  Created by ruckef on 03.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

enum GHKeys : String {
    case id
    case login
    case url
    case avatar_url
    case followers_url
    case per_page
    case page
    case since
    
    var string : String {
        return rawValue
    }
}
