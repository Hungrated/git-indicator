//
//  AppDelegate.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/3.
//  Copyright © 2018年 Zihang Zhang. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    @IBOutlet weak var quit: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let icon = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        icon?.isTemplate = true
        statusItem.title = "Git"
        statusItem.image = icon
        statusItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func quit(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

}

