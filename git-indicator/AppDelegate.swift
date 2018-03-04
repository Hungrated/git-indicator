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
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()
    let pref = NSPopover()
    let menu = NSMenu()
    
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
        
        popover.contentViewController = Indicator(nibName: NSNib.Name(rawValue: "Indicator"), bundle: nil)
        pref.contentViewController = Preferences(nibName: NSNib.Name(rawValue: "Preferences"), bundle: nil)
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitClicked(sender:)), keyEquivalent: "q"))
        statusItem.menu = menu
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
    
    @objc func showPref(sender: AnyObject?) {
        if let button = statusItem.button {
            pref.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    @objc func closePref(sender: AnyObject?) {
        pref.performClose(sender)
    }
    
    @objc func togglePref(sender: AnyObject?) {
        if pref.isShown {
            closePref(sender: sender)
        } else {
            showPref(sender: sender)
        }
    }
}
