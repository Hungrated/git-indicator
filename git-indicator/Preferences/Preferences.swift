//
//  Preferences.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/4.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa

class Preferences: NSViewController {
    @IBOutlet weak var submit: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func submitPref(_ sender: Any) {
        print("submitPref")
    }
    
}
