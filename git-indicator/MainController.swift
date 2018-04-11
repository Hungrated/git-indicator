//
//  MainController.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/24.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa
import ServiceManagement

class MainController: NSObject {
    
    @IBOutlet weak var popover: NSPopover!
    
    var mainIndicator: Indicator?
    
    var eventMonitor: EventMonitor?
    
    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        controllerInit()
        controllerEventMonitor()
        startupAppWhenLogin(startup: true)
    }
    
    // controller func
    
    func controllerInit() {
        mainIndicator = Indicator(nibName: NSNib.Name(rawValue: "Indicator"), bundle: nil)
        Utils.refreshViewFiles()
        popover.contentViewController = mainIndicator
        statusItem.highlightMode = true
        statusItem.button?.target = self
        statusItem.button?.image = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        statusItem.button?.action = #selector(MainController.togglePopover(sender:))
    }
    
    func controllerEventMonitor () {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start()
    }
    
    func startupAppWhenLogin(startup: Bool) {
        let launcherAppIdentifier = "com.hduhungrated.git-indicator-helper"
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, startup)
        var startedAtLogin = false
        for app in NSWorkspace.shared.runningApplications {
            if app.bundleIdentifier == launcherAppIdentifier {
                startedAtLogin = true
            }
        }
        if startedAtLogin {
            DistributedNotificationCenter.default.post(name: NSNotification.Name(rawValue: "killhelper"), object: Bundle.main.bundleIdentifier!)
        }
    }
    
    // popover func
    
    func showPopover(sender: AnyObject?) {
        popover.show(relativeTo: (statusItem.button?.bounds)!, of: statusItem.button!, preferredEdge: NSRectEdge.minY)
        eventMonitor?.start()
        Utils.getDataJson()
        mainIndicator?.refreshMainView()
    }
    
    func closePopover(sender: AnyObject?) {
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
