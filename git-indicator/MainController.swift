//
//  MainController.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/24.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa

class MainController: NSObject {
    
    @IBOutlet weak var popover: NSPopover!
    
    var mainIndicator: Indicator?
    
    var eventMonitor: EventMonitor?
    
    var mainButton: NSButton?
    
    var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        controllerInit()
        controllerEventMonitor()
    }
    
    // controller func
    
    func controllerInit() {
        print("controllerInit")
        mainIndicator = Indicator(nibName: NSNib.Name(rawValue: "Indicator"), bundle: nil)
        Utils.refreshViewFiles()
        popover.contentViewController = mainIndicator
        statusItem.highlightMode = true
        statusItem.target = self
        statusItem.image = NSImage(named: NSImage.Name(rawValue: "StatusIcon"))
        statusItem.action = #selector(MainController.togglePopover(sender:))
    }
    
    func controllerEventMonitor () {
        print("controllerEventMonitor")
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
        eventMonitor?.start()
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
