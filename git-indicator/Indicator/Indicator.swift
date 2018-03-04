//
//  Indicator.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/4.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa

class Indicator: NSViewController {
    
    @IBOutlet weak var preferences: NSButton!
    @IBOutlet weak var quit: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open var windowController: NSWindowController?
    var perfWindowController: NSWindowController?
    
    @IBAction func preferencesClicked(_ sender: AnyObject) {
        // 创建视图控制器，加载xib文件
        let perfViewController = NSViewController(nibName: NSNib.Name(rawValue: "Preferences"), bundle: Bundle.main)
        // 创建窗口，关联控制器
        let perfWindow = NSWindow(contentViewController: perfViewController)
        // 初始化窗口控制器
        perfWindowController = NSWindowController(window: perfWindow)
        // 显示窗口
        perfWindowController?.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
}
