//
//  VirtualFolderManager.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/12/06.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import Foundation

class VirtualFolderManager {
    
    private var folders: [VirtualFolder]!
    
    private init() {
        let base = AppDelegate.applicationDocumentsDirectory.path!
        
        folders = []
        folders.append(VirtualFolder(name: "Inbox", realPath: base.stringByAppendingPathComponent("/Inbox"), options: ["icon": "ic_inbox_black_24dp"]))
        folders.append(VirtualFolder(name: "Documents", realPath: base, options: nil))
    }
    
    class var defaultManager: VirtualFolderManager {
        struct Instance {
            static let i = VirtualFolderManager()
        }
        return Instance.i
    }
    
    func invalidate() {
        for folder in folders {
            folder.invalidate()
        }
    }
    
    func count() -> Int {
        return folders.count
    }
    
    subscript(index: Int) -> VirtualFolder? {
        if index < folders.count {
            return folders[index]
        }
        return nil
    }
    
}