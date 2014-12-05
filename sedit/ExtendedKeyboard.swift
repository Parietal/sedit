//
//  ExtendedKeyboard.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/09/02.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit

class ExtendedKeyboard: UIToolbar {

    weak var textView: UITextView!
    
    init(textView: UITextView) {
        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: 32))
        self.textView = textView

        //self.barTintColor = UIColor.lightGrayColor()
        self.tintColor = UIColor.blackColor()

        self.items = [
            UIBarButtonItem(image: UIImage(named: "ic_keyboard_tab_black_24dp"), style: .Plain, target: self, action: "toolbarTabClick:"),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(named: "ic_keyboard_hide_black_24dp"), style: .Plain, target: self, action: "toolbarCloseClick:")
        ]
    
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK:
    
    func toolbarTabClick(sender: AnyObject?){
        textView?.insertText("\t")
    }
    
    func toolbarCloseClick(sender: AnyObject?) {
        textView?.resignFirstResponder()
    }
    

}
