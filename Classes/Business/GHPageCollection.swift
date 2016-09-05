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
    let size: Int
    // if true starts a next page from lastId+1 otherwise uses a last saved offset
    let offsetById: Bool
}

class GHPageCollection<T:GHUniqueObject> {
    weak var delegate: GHPageCollectionDelegate?
    var preset: GHPageCollectionPreset
    var objects = [T]()
    
    private var offset = UInt64(0)
    private var loading = false
    
    init(preset: GHPageCollectionPreset) {
        self.preset = preset
        load()
    }
    
    var count: Int {
        return objects.count
    }
    
    var pageSize: Int {
        return preset.size
    }
    
    var lastLoadedCount = 0
    
    subscript(index: Int) -> T {
        return objects[index]
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
        var offset = UInt64(0)
        if preset.offsetById {
            let lastId = objects.last?.id
            offset = lastId ?? 0
        } else {
            offset = self.offset
        }
        let params = [preset.sizeKey : preset.size, preset.offsetKey : String(offset)]
        AFHTTPSessionManager().GET(preset.url, parameters: params, progress: nil, success: { (task, response) in
            guard
                let jsonObjects = response as? [Dictionary<String,AnyObject>]
            else {
                completion(error: NSError(domain: "PageCollection", code: 1001, userInfo: [NSLocalizedDescriptionKey : "Failed to parse JSON"]))
                return
            }
            var count = 0
            for jsonObject in jsonObjects {
                if let object = T(jsonDic: jsonObject) {
                    self.objects.append(object)
                    count += 1
                }
            }
            if !self.preset.offsetById {
                self.offset += UInt64(count)
            }
            self.lastLoadedCount = count
            completion(error: nil)
        }) { (task, error) in
            completion(error: error)
        }
    }
}

class GHGitPageCollection<T:GHUniqueObject>: GHPageCollection<T> {
    
    convenience init(url: String, offsetById: Bool) {
        let defaultSize = 20
        self.init(url: url, size: defaultSize, offsetById: offsetById)
    }
    
    init(url: String, size: Int, offsetById: Bool) {
        let offsetKey = offsetById ? GHKeys.since.string : GHKeys.page.string
        let preset = GHPageCollectionPreset(url: url, sizeKey: GHKeys.per_page.string, offsetKey: offsetKey, size: size, offsetById: offsetById)
        super.init(preset: preset)
    }
}

class GHGitUserPageCollection: GHGitPageCollection<GHUser> {
    override init(url: String, size: Int, offsetById: Bool) {
        super.init(url: url, size: size, offsetById: offsetById)
    }
}