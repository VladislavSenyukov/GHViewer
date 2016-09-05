//
//  GHUniqueObject.swift
//  GH Viewer
//
//  Created by ruckef on 03.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

protocol GHDeserializable {
    init?(jsonDic: [String:AnyObject])
}

class GHUniqueObject: GHDeserializable {
    var id: UInt64
    
    required init?(jsonDic: [String : AnyObject]) {
        guard
            let id = jsonDic[GHKeys.id.string] as? NSNumber
        else {
                return nil
        }
        self.id = id.unsignedLongLongValue
    }
}