//
//  VirtualFolderManager.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/12/06.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import Foundation

class VirtualFolderManager {
    
    private var srcFolders: [VirtualFolder]!
    private var visibleFolders: [VirtualFolder]?
    
    private init() {
        let base = AppDelegate.applicationDocumentsDirectory.path!
        srcFolders = []
        for item: [String : AnyObject] in [
            [ "name": "Inbox", "path": base.stringByAppendingPathComponent("/Inbox"), "icon": "ic_inbox_black_24dp", "readOnly": true, "omittable": true ],
            [ "name": "Documents", "path": base, "addable": true ],
            [ "name": "rsrc", "path": NSBundle.mainBundle().resourcePath!, "readOnly": true, "hidden": true ]
            ] {
                srcFolders.append(VirtualFolder(options: item))
        }
    }
    
    class var defaultManager: VirtualFolderManager {
        struct Instance {
            static let i = VirtualFolderManager()
        }
        return Instance.i
    }
    
    func invalidate() {
        visibleFolders = nil
        for folder in srcFolders {
            folder.invalidate()
        }
    }
    
    func getFolders() -> [VirtualFolder]? {
        if visibleFolders == nil {
            visibleFolders = []
            for folder in srcFolders {
                if folder.hidden || (folder.omittable && folder.count() == 0) {
                }else{
                    visibleFolders?.append(folder)
                }
            }
        }
        return visibleFolders
    }
    
    func count() -> Int {
        return getFolders()!.count
    }
    
    subscript(index: Int) -> VirtualFolder? {
        if let folders = getFolders() {
            if index < folders.count {
                return folders[index]
            }
        }
        return nil
    }
    
    func resolv(path: String) -> (path: VirtualFolder, file: String)? {
        let pathComponents = path.pathComponents
        for folder in srcFolders {
            if folder.name == pathComponents[1] {
                return (folder, pathComponents[2])
            }
        }
        return nil
    }
    
}