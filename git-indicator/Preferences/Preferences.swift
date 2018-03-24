//
//  Preferences.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/23.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa
import SwiftHTTP

class Preferences: NSWindowController {

    
    @IBOutlet weak var submit: NSButton!
    @IBOutlet weak var username: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        username.stringValue = Utils.getUsername()
    }
    
    // action func
    
    @IBAction func submitClicked(_ sender: AnyObject) {
        Utils.saveUserData(username: username.stringValue)
        self.close()
    }
}
