//
//  VirtualFolderViewController.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/12/06.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit

class VirtualFolderViewController: UITableViewController {
    
    var folders: [VirtualFolder]!
    
    override init() {
        super.init(style: .Grouped)
        
        let base = AppDelegate.applicationDocumentsDirectory.path!
        
        folders = []
        folders!.append(VirtualFolder(name: "Inbox", realPath: base.stringByAppendingPathComponent("/Inbox"), options: ["icon": "ic_inbox_black_24dp"]))
        folders!.append(VirtualFolder(name: "Documents", realPath: base, options: nil))
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_settings_black_24dp"), style: .Plain, target: self, action: "toolbarSettingsClick:")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toolbarSettingsClick(aNotification: NSNotification?) {
        self.navigationController?.pushViewController(PreferencesViewController(), animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        for folder in folders {
            folder.invalidate()
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders!.count
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // TODO: more modern method
        let cellIdentifier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if let folder = folders?[indexPath.row] {
            cell!.imageView?.image = UIImage(named: folder.prefferedIcon)
            cell!.accessoryType = .DisclosureIndicator
            
            var n_files = 0
            if let files = folder.contentsOfFolder() {
                n_files = files.count
            }
            if n_files > 1 {
                cell!.detailTextLabel!.text = "\( n_files ) Files"
            }else if n_files > 0 {
                cell!.detailTextLabel!.text = "1 File"
            }else{
                cell!.detailTextLabel!.text = "Empty"
            }
            
            cell!.textLabel!.text = folder.name
            cell!.detailTextLabel!.textColor = UIColor.darkGrayColor()
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let folder = folders?[indexPath.row] {
            self.navigationController?.pushViewController(VirtualFolderContentViewController(folder: folder), animated: true)
        }
    }
}
