//
//  Preferences.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/23.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Cocoa
import SwiftHTTP

class Preferences: NSWindowController {

    
    @IBOutlet weak var submit: NSButton!
    @IBOutlet weak var username: NSTextField!
    
    let userDataPath = NSHomeDirectory() + "/Documents/userdata.plist"
    
    override func windowDidLoad() {
        super.windowDidLoad()
        let userDataDict: NSDictionary? = NSDictionary(contentsOfFile: userDataPath)
        username.stringValue = userDataDict!["username"]! as! String
    }
    
    func saveData () {
        let newUserDataDict: NSDictionary = ["username": username.stringValue]
        newUserDataDict.write(toFile: userDataPath, atomically:true)
        print("data submitted: new username \(username.stringValue)")
        getDataJson(username: username.stringValue)
    }
    
    func getDataJson (username: String) {
        HTTP.GET("https://github.com/\(username)") { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return
            }
            let mainPath = NSHomeDirectory() + "/Documents"
            let url = NSURL(fileURLWithPath: "\(mainPath)/data.json")
            let data = NSMutableData()
            data.append(NSData(data: response.description.data(using: String.Encoding.utf8, allowLossyConversion: true)!) as Data)
            data.write(toFile: url.path!, atomically: true)
            print("data.json saved. current user: \(username)")
        }
    }
    
    @IBAction func submitClicked(_ sender: AnyObject) {
        saveData()
        self.close()
    }
}
