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
    
    let sp = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
    var jsonGetCount : Int = 0 {
        didSet {
            print("refresh count: \(String(self.jsonGetCount))")
//            self.refreshMainView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMainViewFromHTML()
    }
    
    // logic func
    
    func refreshIndexHtml () {
        let fileManager = FileManager.default
        let viewPath = "\(sp[0])/index.html"
        let exist = fileManager.fileExists(atPath: viewPath)
        if exist == true {
            try! fileManager.removeItem(atPath: viewPath)
            print("previous index.html removed.")
        }
        let originalPath = Bundle.main.path(forResource: "index", ofType: "html")
        try! fileManager.copyItem(atPath: originalPath!, toPath: viewPath)
        print("index.html saved.")
    }
    
    func getDataJson (username: String) {
        HTTP.GET("https://github.com/\(username)") { (response) in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return
            }
            let url = NSURL(fileURLWithPath: "\(self.sp[0])/data.json")
            let data = NSMutableData()
            data.append(NSData(data: response.description.data(using: String.Encoding.utf8, allowLossyConversion: true)!) as Data)
            data.write(toFile: url.path!, atomically: true)
            self.jsonGetCount = self.jsonGetCount + 1
            print("data.json saved.")
        }
    }
    
    func loadMainViewFromHTML() {
        let url = NSURL.fileURL(withPath:"\(sp[0])/index.html")
        let request = URLRequest(url: url)
        self.mainView.mainFrame.load(request)
    }
    
    func refreshMainView() {
        self.mainView.mainFrame.reload()
        print("in indicator: refresh")
    }
    
    // action func
        
    @IBAction func preferencesClicked(_ sender: AnyObject) {
        let prefViewController = NSViewController(nibName: NSNib.Name(rawValue: "Preferences"), bundle: Bundle.main)
        let prefWindow = NSWindow(contentViewController: prefViewController)
        prefWindowController = NSWindowController(window: prefWindow)
        prefWindowController?.showWindow(nil)
    }
    
    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
}
