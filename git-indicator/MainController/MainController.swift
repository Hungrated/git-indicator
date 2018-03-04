//
//  MainController.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/4.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa

class MainController: NSObject {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()
    let popover = NSPopover()
    
    override func awakeFromNib() {
        controllerInit()
    }
    
    func controllerInit() {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
            button.action = #selector(MainController.togglePopover(sender:))
        }
        
        popover.contentViewController = Indicator(nibName: NSNib.Name(rawValue: "Indicator"), bundle: nil)
        
        menu.addItem(NSMenuItem(title: "退出", action: #selector(MainController.quitClicked(sender:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func quitClicked(sender: AnyObject?) {
        NSApplication.shared.terminate(self)
    }
    
    @objc func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    @objc func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    @objc func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
}

