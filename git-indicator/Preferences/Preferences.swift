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
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    func submitData () {
        print("data submitted.")
    }
    
    @IBAction func submitClicked(_ sender: AnyObject) {
        submitData()
        self.close()
    }
}
