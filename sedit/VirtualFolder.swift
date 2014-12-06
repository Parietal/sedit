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

    private var files: [String]?
    
    init(name: String, realPath: String, options: [String: String]?) {
        self.name = name
        self.realPath = realPath
        
        if let options = options? {
            if let prefferedIcon = options["icon"] {
                self.icon = prefferedIcon
            }
        }
        
        if icon == nil {
            icon = "ic_folder_black_24dp"
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
