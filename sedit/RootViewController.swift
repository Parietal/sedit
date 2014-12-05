//
//  RootViewController.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/08/31.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.translucent = false
        navigationBar.barTintColor = UIColor(white: 0.25, alpha: 1.0)
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        toolbarHidden = false
        toolbar.translucent = navigationBar.translucent
        toolbar.barTintColor = navigationBar.barTintColor
        toolbar.tintColor = navigationBar.tintColor
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
