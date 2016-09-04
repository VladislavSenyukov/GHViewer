//
//  GHPageCollection.swift
//  GH Viewer
//
//  Created by ruckef on 04.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

protocol GHPageCollectionInterface {
    
}

struct GHPageCollectionPreset {
    let url: String
    let sizeKey: String
    let offsetKey: String
    let size: UInt
}

class GHPageCollection<T:GHDeserializable> : GHPageCollectionInterface {
    private var objects = [T]()
    private var preset: GHPageCollectionPreset
    private var offset = UInt(0)
    
    init(preset: GHPageCollectionPreset) {
        self.preset = preset
    }
}

class GHGitPageCollection<T:GHDeserializable>: GHPageCollection<T> {
    convenience init(url: String) {
        let defaultSize = UInt(20)
        self.init(url: url, size: defaultSize)
    }
    
    init(url: String, size: UInt) {
        let preset = GHPageCollectionPreset(url: url, sizeKey: GHKeys.per_page.string, offsetKey: GHKeys.since.string, size: size)
        super.init(preset: preset)
    }
}

class GHGitUserPageCollection: GHGitPageCollection<GHUser> {}