//
//  Indicator.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/4.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa
import WebKit

class Indicator: NSViewController {
    
    @IBOutlet weak var mainView: WebView!
    @IBOutlet weak var refresh: NSButton!
    @IBOutlet weak var preferences: NSButton!
    @IBOutlet weak var quit: NSButton!
    
    var windowController: NSWindowController?
    var perfWindowController: NSWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMainView()
    }
    
    func loadMainView() {
        if let path = Bundle.main.path(forResource: "index", ofType: "html"){
            
            let url = NSURL.fileURL(withPath: path)
            
            let request = URLRequest(url: url)
            
            self.mainView.mainFrame.load(request)
            
        }
    }
    
//    @IBAction func refreshClicked(_ sender: AnyObject) {
//        self.mainView.mainFrame.reload()
//    }
    
    @IBAction func preferencesClicked(_ sender: AnyObject) {
        
        let perfViewController = NSViewController(nibName: NSNib.Name(rawValue: "Preferences"), bundle: Bundle.main)
        
        let perfWindow = NSWindow(contentViewController: perfViewController)
        
        perfWindowController = NSWindowController(window: perfWindow)
        
        perfWindowController?.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
}
