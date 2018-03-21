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
        loadMainView(username: "Hungrated")
    }
    
    func loadMainView(username: String) {
        let sp = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: "\(sp[0])/index.html")
        if exist == false {
            archiveUserData(username: username)
        }
        loadMainViewFromHTML()
    }
    
    func loadMainViewFromHTML() {
        let sp = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        let url = NSURL.fileURL(withPath:"\(sp[0])/index.html")
        let request = URLRequest(url: url)
        self.mainView.mainFrame.load(request)
    }
    
    func refreshMainView(username: String) {
        let sp = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: "\(sp[0])/index.html")
        if exist == true {
            try! fileManager.removeItem(atPath: "\(sp[0])/index.html")
        }
        saveWebviewData(userData: username)
    }
    
    func archiveUserData(username: String) {
        HTTP.GET("https://github.com/\(username)") { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
            }
            print(response.description)
            self.saveWebviewData(userData: response.description)
        }
    }
    
    func saveWebviewData(userData: String) {
        var sp = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        if sp.count > 0 {
            // 1 copy index.html if not exist
            let fileManager = FileManager.default
            let viewPath = "\(sp[0])/index.html"
            let exist = fileManager.fileExists(atPath: viewPath)
            if exist == true {
                print("index.html already exists")
            } else {
                let originalPath = Bundle.main.path(forResource: "index", ofType: "html")
                try! fileManager.copyItem(atPath: originalPath!, toPath: viewPath)
                print("index.html saved")
            }
            
            // 2 save data.json
            let url = NSURL(fileURLWithPath: "\(sp[0])/data.json")
            print(url)
            let data = NSMutableData()
            data.append(NSData(data: userData.data(using: String.Encoding.utf8, allowLossyConversion: true)!) as Data)
            data.write(toFile: url.path!, atomically: true)
            print("data.json saved")
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
}
