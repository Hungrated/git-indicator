//
//  Indicator.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/3.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa

class Indicator: NSObject {
    

    let statusItem = NSStatusBar.system.statusItem(withLength: -1)
    
    override func awakeFromNib() {
        
        print("hello")
        
    }
}
