//
//  VirtualFolder.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/12/06.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit

class VirtualFolder {

    var name: String!
    var realPath: String!
    var prefferedIcon: String!

    private var files: [String]?
    
    init(name: String, realPath: String, options: [String: String]?) {
        self.name = name
        self.realPath = realPath
        
        if let options = options? {
            if let prefferedIcon = options["icon"] {
                self.prefferedIcon = prefferedIcon
            }
        }
        
        if prefferedIcon == nil {
            prefferedIcon = "ic_folder_black_24dp"
        }
    
    }
    
    func contentsOfFolder() -> [String]? {
        if files == nil {
            var filtered = [String]()
            if let srcdir = NSFileManager.defaultManager().contentsOfDirectoryAtPath(realPath, error: nil) as? [String] {
                for content in srcdir {
                    let file = realPath.stringByAppendingPathComponent(content)
                    if let attrs = NSFileManager.defaultManager().attributesOfItemAtPath(file, error: nil) as NSDictionary? {
                        if attrs.fileType() == NSFileTypeRegular {
                            filtered.append(content)
                        }
                    }
                }
                files = filtered.sorted() { (s1, s2) -> Bool in
                    return s1.stringByDeletingPathExtension.compare(s2.stringByDeletingPathExtension, options: .CaseInsensitiveSearch | .NumericSearch, range: nil, locale: NSLocale.systemLocale()) == NSComparisonResult.OrderedAscending
                }
            }
        }
        return files
    }
    
    func invalidate() {
        files = nil
    }
    
    func reloadContents() -> [String]? {
        invalidate()
        return contentsOfFolder()
    }
    
}
