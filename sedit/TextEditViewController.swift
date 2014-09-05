//
//  TextEditViewController.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/08/31.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit

class TextEditViewController: UIViewController, UITextViewDelegate {

    let currentFilePath: String!
    var textView: UITextView!
    
    var dirty = false
    var textHash: String? = nil
    var documentInteractionController: UIDocumentInteractionController?
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
        
    }
    
    init(path: String) {
        super.init()
        currentFilePath = path
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        let fontBody = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        textView = UITextView(frame: rectForTextView(self.view.bounds))
        textView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        textView.editable = true
        textView.alwaysBounceVertical = true
        textView.backgroundColor = UIColor.whiteColor()
        textView.textColor = UIColor.blackColor()
        textView.delegate = self
        textView.font = UIFont(name: "Menlo", size: fontBody.pointSize)
        textView.text = loadFile()
        textView.selectedRange = NSRange(location: 0, length: 0)
        textView.inputAccessoryView = ExtendedKeyboard(textView: textView)
        //textView.keyboardAppearance = .Dark
        self.view.addSubview(textView)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "navigationItemActionClick:")
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateDirtyState()
        textView.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        let viewControllers = self.navigationController!.viewControllers as NSArray
        if !viewControllers.containsObject(self) {
            saveFile()
        }
        super.viewWillDisappear(animated)
        self.title = ""
    }

    
    // MARK:

    func truncateString(src: String) -> String {
        let str = NSString(string: src)
        let cs = NSCharacterSet.whitespaceAndNewlineCharacterSet()

        for(var i=str.length-1; i>=0; i--){
            if !cs.characterIsMember(str.characterAtIndex(i)) {
                return str.substringToIndex(i+1) + "\n"
            }
        }
        
        return ""
    }
    
    func getLineAt(basis: Int) -> NSRange {
        var text = textView.text as NSString
        var result = NSMakeRange(basis, 0)
        
        if result.location>0 {
            for(var i=result.location-1; i>0; i--){
                if text.characterAtIndex(i) == 10 /* \n */ {
                    result.location = i+1
                    break
                }
            }
        }
        
        let limit = text.length
        for(var i=result.location; i<limit; i++){
            if text.characterAtIndex(i) == 10 /* \n */ {
                result.length = i-result.location
                break
            }
        }
        
        return result
    }
    
    func loadFile() -> String {
        var error: NSError?
        let defaultString = "\n\n\n\n"
        dirty = false
        updateDirtyState()
        let result = truncateString(String.stringWithContentsOfFile(currentFilePath, encoding: NSUTF8StringEncoding, error: &error)!)
        textHash = result.sha256().base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
        return result + defaultString
    }

    func saveFile() -> NSError? {
        var error: NSError?
        if dirty {
            let text = truncateString(textView.text)
            let newHash = text.sha256().base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
            if newHash != textHash {
                text.writeToFile(currentFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
                if error != nil {
                    return error
                }
                textHash = newHash
            }
            
            dirty = false
            updateDirtyState()
        }
        return nil
    }
    
    func updateDirtyState() {
        let filename = currentFilePath.lastPathComponent.stringByDeletingPathExtension
        if(dirty){
            self.title = filename + " *"
        }else{
            self.title = filename
        }
    }
    
    func rectForTextView(frame: CGRect) -> CGRect {
        let marginTop: CGFloat = 0.0
        let marginBottom: CGFloat = 2.0

        var result = frame
        result.origin.y += marginTop
        result.size.height -= (marginTop + marginBottom)
        return result
    }
    
    func navigationItemActionClick(sender: AnyObject?) {
        saveFile()
        
        documentInteractionController = UIDocumentInteractionController(URL: NSURL(fileURLWithPath: currentFilePath))
        documentInteractionController!.presentOptionsMenuFromBarButtonItem(sender! as UIBarButtonItem, animated: true)
    }

    
    // MARK:
    
    func textViewDidChangeSelection(textView: UITextView) {
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    func textViewDidChange(textView: UITextView) {
        if !dirty {
            dirty = true
            updateDirtyState()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if range.length == 0 && text == "\n" {
            let src = textView.text as NSString
            var rangeLine = getLineAt(range.location)
            var newRange = NSMakeRange(range.location+1, 0)
            var replaceString = NSMutableString(string:"\n")
            for(var i=0; i<rangeLine.length;i++){
                if src.characterAtIndex(rangeLine.location+i) == 9 /* \t */ {
                    replaceString.appendString("\t")
                    newRange.location++;
                }else{
                    break
                }
            }
            textView.replaceRange(textView.selectedTextRange!, withText: replaceString)
            textView.selectedRange = newRange
            textView.scrollRangeToVisible(newRange)
            self.textViewDidChange(textView)
            return false
        }else{
            return true
        }
    }
    
    
    //  MARK:
    
    func keyboardWillShow(aNotification: NSNotification?) {
        
        let userInfo = aNotification?.userInfo as NSDictionary!
        let keyFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue
        let keyboardRect = self.view.convertRect(keyFrame.CGRectValue(), fromView: nil)
        
        var baseRect = self.view.bounds
        baseRect.size.height = keyboardRect.origin.y
        self.textView.frame = rectForTextView(baseRect)
        
    }
    
    func keyboardWillHide(aNotification: NSNotification?) {
        self.textView.frame = rectForTextView(self.view.bounds)
    }
    
    func applicationWillResignActive(aNotification: NSNotification?) {
        saveFile()
    }

}