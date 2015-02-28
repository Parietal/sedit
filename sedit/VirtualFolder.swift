//
//  VirtualFolder.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/12/06.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import Foundation

class VirtualFolder {

    var name: String!
    var realPath: String!
    var icon: String!
    var hidden = false, omittable = false, addable = false, readOnly = false

    private var files: [String]?
    
    init(options: [String: AnyObject]) {
        if let s = options["name"] as? String {
            self.name = s
        }
        if let s = options["path"] as? String {
            self.realPath = s
        }
        if let s = options["icon"] as? String {
            self.icon = s
        }
        if let flag = options["hidden"] as? Bool {
            self.hidden = flag
        }
        if let flag = options["omittable"] as? Bool {
            self.omittable = flag
        }
        if let flag = options["addable"] as? Bool {
            self.addable = flag
        }
        if let flag = options["readOnly"] as? Bool {
            self.readOnly = flag
        }
        
        if self.icon == nil {
            self.icon = "ic_folder_black_24dp"
        }
        
    }

    func invalidate() {
        files = nil
    }
    
    func loadContentsOfFolder() {
        if files == nil {
            if let dir = NSFileManager.defaultManager().contentsOfDirectoryAtPath(realPath, error: nil) as? [String] {
                var _files = [String]()
                for file in dir {
                    if file.hasPrefix(".") {
                        continue
                    }
                    let path = realPath.stringByAppendingPathComponent(file)
                    if let attrs = NSFileManager.defaultManager().attributesOfItemAtPath(path, error: nil) as NSDictionary? {
                        if attrs.fileType() == NSFileTypeRegular {
                            _files.append(file)
                        }
                    }
                }
                files = _files.sorted() { (s1, s2) -> Bool in
                    return s1.stringByDeletingPathExtension.compare(s2.stringByDeletingPathExtension, options: .CaseInsensitiveSearch | .NumericSearch, range: nil, locale: NSLocale.systemLocale()) == NSComparisonResult.OrderedAscending
                }
            }
        }
    }

    func count() -> Int {
        loadContentsOfFolder()
        if let files = files {
            return files.count
        }else{
            return 0
        }
    }
    
    subscript(index: Int) -> String? {
        loadContentsOfFolder()
        if let files = files {
            return files[index]
        }else{
            return nil
        }
    }

    func realPath(atIndex: Int) -> String? {
        if let file = self[atIndex] {
            return realPath.stringByAppendingPathComponent(file)
        }else{
            return nil
        }
    }

}
