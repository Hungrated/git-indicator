//
//  Indicator.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/4.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa
import WebKit
import SwiftHTTP

class Indicator: NSViewController {
    
    @IBOutlet weak var mainView: WebView!
    @IBOutlet weak var refresh: NSButton!
    @IBOutlet weak var preferences: NSButton!
    @IBOutlet weak var quit: NSButton!
    
    var prefWindowController = Preferences(windowNibName: NSNib.Name(rawValue: "Preferences"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMainViewFromHTML()
    }
    
    // logic func
    
    func refreshViewFiles () {
        Utils.refreshFile(resource: "index", type: "html", overwrite: true)
        Utils.refreshFile(resource: "bundle", type: "js")
        Utils.refreshFile(resource: "userdata", type: "plist")
    }
    
    func loadMainViewFromHTML() {
        let url = NSURL.fileURL(withPath:"\(Utils.FILE_DIR)/index.html")
        let request = URLRequest(url: url)
        self.mainView.mainFrame.load(request)
    }
    
    func refreshMainView() {
        self.mainView.mainFrame.reload()
        print("refreshed.")
    }
    
    // action func
        
    @IBAction func preferencesClicked(_ sender: AnyObject) {
        prefWindowController.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
}
