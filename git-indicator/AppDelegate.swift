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
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        controllerInit()
        controllerEventMonitor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {}
    
    func controllerInit() {
        statusItem.highlightMode = true
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
            button.action = #selector(togglePopover(sender:))
        }
        mainIndicator = Indicator(nibName: NSNib.Name(rawValue: "Indicator"), bundle: nil)
        mainIndicator?.refreshIndexHtml()
        mainIndicator?.refreshBundleJs()
        popover.contentViewController = mainIndicator        
    }
    
    
    func controllerEventMonitor () {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start();
    }
    
    @objc func quitClicked(sender: AnyObject?) {
        NSApplication.shared.terminate(self)
    }
    
    @objc func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
            self.mainIndicator?.getDataJson(username: "Hungrated")
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
