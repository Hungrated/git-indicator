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
    let mainPath = NSHomeDirectory() + "/Documents"
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
    
    func refreshFile (resource: String, type: String) {
        let fileManager = FileManager.default
        let filePath = "\(mainPath)/\(resource).\(type)"
        let exist = fileManager.fileExists(atPath: filePath)
        if exist == true {
            try! fileManager.removeItem(atPath: filePath)
            print("previous \(resource).\(type) removed.")
        }
        let originalPath = Bundle.main.path(forResource: resource, ofType: type)
        try! fileManager.copyItem(atPath: originalPath!, toPath: filePath)
        print("\(resource).\(type) saved.")
    }
    
    func refreshFileIfNotExist (resource: String, type: String) {
        let fileManager = FileManager.default
        let filePath = "\(mainPath)/\(resource).\(type)"
        let exist = fileManager.fileExists(atPath: filePath)
        if exist == false {
            let originalPath = Bundle.main.path(forResource: resource, ofType: type)
            try! fileManager.copyItem(atPath: originalPath!, toPath: filePath)
            print("\(resource).\(type) saved.")
        } else {
            print("\(resource).\(type) exists.")
        }
    }
    
    func refreshViewFile () {
        refreshFile(resource: "index", type: "html")
        refreshFileIfNotExist(resource: "bundle", type: "js")
        refreshFileIfNotExist(resource: "userdata", type: "plist")
    }
    
    func getDataJson (username: String) {
        HTTP.GET("https://github.com/\(username)") { (response) in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return
            }
            let url = NSURL(fileURLWithPath: "\(self.mainPath)/data.json")
            let data = NSMutableData()
            data.append(NSData(data: response.description.data(using: String.Encoding.utf8, allowLossyConversion: true)!) as Data)
            data.write(toFile: url.path!, atomically: true)
            self.jsonGetCount = self.jsonGetCount + 1
            print("data.json saved. current user: \(username)")
        }
    }
    
    func loadMainViewFromHTML() {
        let url = NSURL.fileURL(withPath:"\(mainPath)/index.html")
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
