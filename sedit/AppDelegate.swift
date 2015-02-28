//
//  AppDelegate.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/08/31.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    class var applicationDocumentsDirectory: NSURL {
        get {
            let fm = NSFileManager.defaultManager()
            return fm.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as! NSURL
        }
    }

    class func presentPopoverMenu() {
        PopoverMenuManager.defaultManager.presentPopoverMenu(VirtualFolderViewController())
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
        let files = NSFileManager.defaultManager().contentsOfDirectoryAtPath(AppDelegate.applicationDocumentsDirectory.path!, error: nil)
        if files?.count == 0 {
            let srcPath = NSBundle.mainBundle().pathForResource("sample", ofType: "txt")
            let data = String(contentsOfFile: srcPath!, encoding: NSUTF8StringEncoding, error: nil)
            data?.writeToFile(AppDelegate.applicationDocumentsDirectory.path!.stringByAppendingPathComponent("sample.txt"), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = RootViewController(rootViewController: TextEditViewController(path: "/rsrc/welcome.txt"))
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        if url.scheme == "file" {
            let localPath = url.path?.lowercaseString as NSString?
            if (localPath?.containsString("/inbox/") != nil) {
                self.openPath("/Inbox/"+url.lastPathComponent!)
                return true
            }
        }
        
        return true
    }
    
    /*
    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    */
    

    // MARK:
    
    class func openPath(path: String) -> Bool {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return appDelegate.openPath(path)
        }
        return false
    }
    
    func openPath(path: String) -> Bool {
        //  TODO:
        let rootViewController = self.window?.rootViewController as! RootViewController!
        var vc = TextEditViewController(path: path)
        rootViewController.viewControllers = [vc]
        
        return true
    }
    
}

