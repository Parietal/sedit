//
//  VirtualFolderContentViewController.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/12/06.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit

class VirtualFolderContentViewController: UITableViewController {

    var cwd: VirtualFolder!
    
    init(folder: VirtualFolder) {
        super.init(style: .Grouped)
        
        cwd = folder
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = cwd.name
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func navigationItemAddClick(sender: AnyObject?){
        let fm = NSFileManager.defaultManager()
        let newFilePath = cwd.realPath.stringByAppendingPathComponent("Untitled.txt")
        if !fm.fileExistsAtPath(newFilePath) {
            let result = fm.createFileAtPath(newFilePath, contents: nil, attributes: nil)
        }else{
            for(var i=1; i<9999; i++){
                let newFilePath = cwd.realPath.stringByAppendingPathComponent("Untitled \(i).txt")
                if !fm.fileExistsAtPath(newFilePath) {
                    let result = fm.createFileAtPath(newFilePath, contents: nil, attributes: nil)
                    break;
                }
            }
        }
        
        checkReload(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkReload(true)
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_note_add_black_24dp"), style: .Plain, target: self, action: "navigationItemAddClick:")
        }else{
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func checkReload(reload: Bool) -> Bool {
        var result = true
        cwd.invalidate()
        if(result && reload) {
            tableView.reloadData()
        }
        return result
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cwd.count()
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if cwd.count() > 0 {
            return nil
        }else{
            return "THIS FOLDER IS EMPTY"
        }
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
        
        if let file = cwd[indexPath.row] {
            let path = cwd.realPath(indexPath.row)!
            if let attrs = NSFileManager.defaultManager().attributesOfItemAtPath(path, error: nil) as NSDictionary? {
                let filesize = attrs.fileSize()
                let filetype = attrs.fileType()
                let isDir = (filetype == NSFileTypeDirectory)
                
                cell!.detailTextLabel!.text =
                    filesize>0 ? "\( filesize ) bytes" : "Empty"
                
                if isDir {
                    cell!.accessoryType = .DisclosureIndicator
                }else{
                    cell!.imageView!.image = UIImage(named: "ic_description_black_24dp")
                    cell!.accessoryType = .None
                }
                
            }else{
                cell!.detailTextLabel?.text = ""
                cell!.accessoryType = .None
            }
            
            cell!.textLabel!.text = file.stringByDeletingPathExtension
            cell!.detailTextLabel!.textColor = UIColor.darkGrayColor()
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let path = cwd.realPath(indexPath.row) {
            let attrs = NSFileManager.defaultManager().attributesOfItemAtPath(path, error: nil) as NSDictionary?
            if attrs?.fileType() == NSFileTypeDirectory {
                //self.navigationController!.pushViewController(MainViewController(path: self.rel_cwd+"/"+lpc), animated: true)
            }else{
                self.navigationController!.pushViewController(TextEditViewController(path: path), animated: true)
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let path = cwd.realPath(indexPath.row) {
            if editingStyle == .Delete {
                var error: NSError?
                NSFileManager.defaultManager().removeItemAtPath(path, error: &error)
                if (error != nil) {
                    NSLog("\(__FUNCTION__): %@", error!)
                }else{
                    checkReload(false)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            } else if editingStyle == .Insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
    }

}
