//
//  TextEditViewController.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/08/31.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import UIKit

class TextEditViewController: UIViewController, UITextViewDelegate {

    var currentPath: VirtualFolder?
    var currentFilePath: String?
    var textView: UITextView!
    var isReadOnly = false
    
    var dirty = false
    var textHash: String? = nil
    var documentInteractionController: UIDocumentInteractionController?
    
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryDidCHange:", name: UIContentSizeCategoryDidChangeNotification, object: nil)

    }
    
    init(path: String) {
        super.init()
        setOpenFilePath(path)
    }

    func setOpenFilePath(path: String) {
        if let r = VirtualFolderManager.defaultManager.resolv(path) {
            currentPath = r.path
            currentFilePath = r.path.realPath.stringByAppendingPathComponent(r.file)
            isReadOnly = r.path.readOnly
        }else{
            currentPath = nil
            currentFilePath = nil
            isReadOnly = false
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        saveFile()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

        textView = UITextView(frame: rectForTextView(self.view.bounds))
        textView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        textView.editable = !isReadOnly
        textView.alwaysBounceVertical = true
        textView.backgroundColor = UIColor.whiteColor()
        textView.textColor = UIColor.blackColor()
        textView.delegate = self
        textView.text = loadFile()
        textView.selectedRange = NSRange(location: 0, length: 0)
        textView.inputAccessoryView = ExtendedKeyboard(textView: textView)
        //textView.keyboardAppearance = .Dark
        self.view.addSubview(textView)
        setFont()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_black_24dp"), style: .Plain, target: self, action: "toolbarMenuClick:")

        if !isReadOnly {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "navigationItemActionClick:")
        }
    }

    func toolbarMenuClick(aNotification: NSNotification?) {
        AppDelegate.presentPopoverMenu()
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateDirtyState()
        if !isReadOnly {
            textView.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers as NSArray? {
            if !viewControllers.containsObject(self) {
                saveFile()
            }
        }
        super.viewWillDisappear(animated)
        self.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        saveFile()
    }
    
    // MARK:

    func setFont() {
        let fontBody = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        textView.font = UIFont(name: "Menlo", size: fontBody.pointSize)
    }
    
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
        let result = truncateString(String(contentsOfFile: currentFilePath!, encoding: NSUTF8StringEncoding, error: &error)!)
        textHash = result.sha256().base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
        return result + defaultString
    }

    func saveFile() -> NSError? {
        var error: NSError?
        if dirty {
            let text = truncateString(textView.text)
            let newHash = text.sha256().base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
            if newHash != textHash {
                text.writeToFile(currentFilePath!, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
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
        let filename = currentFilePath!.lastPathComponent.stringByDeletingPathExtension
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
        
        documentInteractionController = UIDocumentInteractionController(URL: NSURL(fileURLWithPath: currentFilePath!)!)
        documentInteractionController!.presentOptionsMenuFromBarButtonItem(sender! as! UIBarButtonItem, animated: true)
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
            textView.replaceRange(textView.selectedTextRange!, withText: replaceString as String)
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
        let keyFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
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
    
    func contentSizeCategoryDidCHange(aNotification: NSNotification?) {
        setFont()
    }

}
