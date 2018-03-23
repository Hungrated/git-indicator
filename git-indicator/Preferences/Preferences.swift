//
//  Preferences.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/23.
//  Copyright © 2018年 Zihang Zhang. All rights reserved.
//

import Cocoa

class Preferences: NSWindowController {

    
    @IBOutlet weak var submit: NSButton!
    @IBOutlet weak var username: NSTextField!
    
    let userDataPath = NSHomeDirectory() + "/Documents/userdata.plist"
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let userDataDict: NSDictionary? = NSDictionary(contentsOfFile: userDataPath)
        username.stringValue = userDataDict!["username"]! as! String
    }
    
    func saveData () {
        let newUserDataDict: NSDictionary = ["username": username.stringValue]
        newUserDataDict.write(toFile: userDataPath, atomically:true)
        print("data submitted: new username \(username.stringValue)")
    }
    
    @IBAction func submitClicked(_ sender: AnyObject) {
        saveData()
        self.close()
    }
}
