//
//  VirtualFolderViewController.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/12/06.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit

class VirtualFolderViewController: UITableViewController {
    
    init() {
        super.init(style: .Grouped)
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_black_24dp"), style: .Plain, target: self, action: "toolbarMenuClick:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_settings_black_24dp"), style: .Plain, target: self, action: "toolbarSettingsClick:")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toolbarMenuClick(aNotification: NSNotification?) {
        PopoverMenuManager.defaultManager.dismissPopoverMenu()
    }
    
    func toolbarSettingsClick(aNotification: NSNotification?) {
        self.navigationController?.pushViewController(PreferencesViewController(), animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        VirtualFolderManager.defaultManager.invalidate()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VirtualFolderManager.defaultManager.count()
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
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if let folder = VirtualFolderManager.defaultManager[indexPath.row] {
            cell!.imageView?.image = UIImage(named: folder.icon)
            cell!.accessoryType = .DisclosureIndicator
            
            var n = folder.count()
            if n > 1 {
                cell!.detailTextLabel!.text = "\( n ) files"
            }else if n > 0 {
                cell!.detailTextLabel!.text = "1 file"
            }else{
                cell!.detailTextLabel!.text = "Empty"
            }
            
            cell!.textLabel!.text = folder.name
            cell!.detailTextLabel!.textColor = UIColor.darkGrayColor()
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "FOLDERS"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let folder = VirtualFolderManager.defaultManager[indexPath.row] {
            self.navigationController?.pushViewController(VirtualFolderContentViewController(folder: folder), animated: true)
        }
    }
}
