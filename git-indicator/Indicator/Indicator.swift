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
    
    var windowController: NSWindowController?
    var prefWindowController: NSWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMainView()
    }
    
    func loadMainView() {
        if let path = Bundle.main.path(forResource: "index", ofType: "html"){
            let url = NSURL.fileURL(withPath: path)
            let request = URLRequest(url: url)
            self.mainView.mainFrame.load(request)
            self.getGithubUserData(username: "Hungrated")
        }
    }    
    
    @IBAction func preferencesClicked(_ sender: AnyObject) {
        let prefViewController = NSViewController(nibName: NSNib.Name(rawValue: "Preferences"), bundle: Bundle.main)
        let prefWindow = NSWindow(contentViewController: prefViewController)
        prefWindowController = NSWindowController(window: prefWindow)
        prefWindowController?.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
    
    func getGithubUserData(username: String) {
        HTTP.GET("https://github.com/\(username)") { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return
            }
            print("opt finished: \(response.description)")
            self.initWebviewData(data: response.description)
        }
    }
    
    func initWebviewData(data: String) {
        
    }
}
