 //
//  PopoverMenuWindow.swift
//  sedit
//
//  Created by Nerry Kitazato on 2015/02/26.
//  Copyright (c) 2015年 Nerry Kitazato. All rights reserved.
//

import UIKit


class PopoverMenuWindow: UIWindow {

    override init(frame: CGRect) {
        super.init(frame: frame)

        windowLevel = 5;
        backgroundColor = UIColor(white: 0.0, alpha: 0.5);
        alpha = 0.0;

        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "onSwipeGesture:")
        swipeGesture.direction = .Left
        self.addGestureRecognizer(swipeGesture)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onSwipeGesture(sender: AnyObject?) {
        PopoverMenuManager.defaultManager.dismissPopoverMenu()
    }
    
    class func presentPopoverMenu(vc: UIViewController?) -> PopoverMenuWindow {
        let result = PopoverMenuWindow(frame: UIScreen.mainScreen().bounds)
        result.rootViewController = PopoverMenuRootViewController(rootViewController: vc!)
        result.makeKeyAndVisible()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            result.alpha = 1.0;
        })
        return result
    }

    func dismissPopoverMenu(completion: () -> Void) {
        var image: UIImage?
        if let view = self.rootViewController?.view {
            UIGraphicsBeginImageContext(view.bounds.size)
            let ctx = UIGraphicsGetCurrentContext()
            view.layer .renderInContext(ctx)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        self.rootViewController = nil

        UIView.animateWithDuration(0.25, animations: { () -> Void in
            imageView.frame.origin.x = -imageView.frame.size.width
            self.alpha = 0.0
        }) { (finished) -> Void in
            if finished {
                self.hidden = true
                completion()
            }
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
