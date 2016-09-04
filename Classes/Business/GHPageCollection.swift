//
//  GHPageCollection.swift
//  GH Viewer
//
//  Created by ruckef on 04.09.16.
//  Copyright © 2016 ruckef. All rights reserved.
//

import AFNetworking

protocol GHPageCollectionDelegate : class {
    func pageCollectionDidLoadPage()
    func pageCollectionDidFail(error: NSError)
}

extension GHPageCollectionDelegate {
    func pageCollectionDidFail(error: NSError) {}
}

struct GHPageCollectionPreset {
    let url: String
    let sizeKey: String
    let offsetKey: String
    let size: UInt
}

class GHPageCollection<T:GHDeserializable> {
    weak var delegate: GHPageCollectionDelegate?
    var preset: GHPageCollectionPreset
    var objects = [T]()
    
    private var offset = UInt(0)
    private var loading = false
    
    init(preset: GHPageCollectionPreset) {
        self.preset = preset
        load()
    }
    
    func load() {
        if !loading {
            loadNext({ (error) in
                self.loading = false
                if error != nil {
                    self.delegate?.pageCollectionDidFail(error!)
                } else {
                    self.delegate?.pageCollectionDidLoadPage()
                }
            })
        }
    }
    
    typealias LoadCompletion = (error: NSError?) -> ()
    
    func loadNext(completion: LoadCompletion) {
        loading = true
        let offset = self.offset
        let params = [preset.sizeKey : preset.size, preset.offsetKey : offset]
        AFHTTPSessionManager().GET(preset.url, parameters: params, progress: nil, success: { (task, response) in
            guard
                let jsonObjects = response as? [Dictionary<String,AnyObject>]
            else {
                completion(error: NSError(domain: "PageCollection", code: 1001, userInfo: [NSLocalizedDescriptionKey : "Failed to parse JSON"]))
                return
            }
            var count = UInt(0)
            for jsonObject in jsonObjects {
                if let object = T(jsonDic: jsonObject) {
                    self.objects.append(object)
                    count += 1
                }
            }
            self.offset += count
            completion(error: nil)
        }) { (task, error) in
            completion(error: error)
        }
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

class GHGitUserPageCollection: GHGitPageCollection<GHUser> {
    override init(url: String, size: UInt) {
        super.init(url: url, size: size)
    }
}