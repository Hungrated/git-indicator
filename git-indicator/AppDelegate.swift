//
//  AppDelegate.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/3.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var popover: NSPopover!
    
    var mainIndicator: Indicator?
    
    var eventMonitor: EventMonitor?
    
    var mainButton: NSButton?
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        controllerInit()
        controllerEventMonitor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {}
    
    // controller func
    
    func controllerInit() {
        statusItem.highlightMode = true
        mainButton = statusItem.button
        mainButton?.image = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        mainButton?.action = #selector(togglePopover(sender:))
        mainIndicator = Indicator(nibName: NSNib.Name(rawValue: "Indicator"), bundle: nil)
        mainIndicator?.refreshViewFiles()
        popover.contentViewController = mainIndicator
    }
    
    func controllerEventMonitor () {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start()
    }
    
    // popover func
    
    @objc func showPopover(sender: AnyObject?) {
        if mainButton != nil {
            popover.show(relativeTo: (mainButton?.bounds)!, of: mainButton!, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
            Utils.getDataJson()
            self.mainIndicator?.refreshMainView()
        }
    }
    
    @objc func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    @objc func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
}
