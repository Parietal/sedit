//
//  PopoverMenuRootViewController.swift
//  sedit
//
//  Created by Nerry Kitazato on 2015/02/26.
//  Copyright (c) 2015年 Nerry Kitazato. All rights reserved.
//

import UIKit

let preferredWidth: CGFloat = 288

class PopoverMenuRootViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.translucent = false
        navigationBar.barTintColor = UIColor.purpleColor()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        /*
        toolbarHidden = false
        toolbar.translucent = navigationBar.translucent
        toolbar.barTintColor = navigationBar.barTintColor
        toolbar.tintColor = navigationBar.tintColor
        */

    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.view.frame.origin.x = -preferredWidth

        self.view.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin
        self.view.frame.size.width = 0
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.frame.origin.x = 0
        })
    }
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
    override func viewWillLayoutSubviews() {
        self.view.frame.size.width = preferredWidth
        super.viewWillLayoutSubviews()
    }

}
