//
//  Indicator.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/3.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa

class Indicator: NSObject {
    
    @IBOutlet weak internal var popView: NSPopover!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        print("hello")
    }

}
