//
//  PopoverMenuManager.swift
//  sedit
//
//  Created by Nerry Kitazato on 2015/02/27.
//  Copyright (c) 2015年 Nerry Kitazato. All rights reserved.
//

import UIKit

class PopoverMenuManager {

    var menuWindow: PopoverMenuWindow?

    private init() {
    }
    
    class var defaultManager: PopoverMenuManager {
        struct Instance {
            static let i = PopoverMenuManager()
        }
        return Instance.i
    }

    func presentPopoverMenu(viewController: UIViewController?) {
        self.menuWindow = PopoverMenuWindow.presentPopoverMenu(viewController)
    }
    
    func dismissPopoverMenu() {
        if self.menuWindow != nil {
            self.menuWindow?.dismissPopoverMenu() {
                self.menuWindow = nil
            }
        }
    }
    

}
