//
//  Utils.swift
//  git-indicator
//
//  Created by Zihang Zhang on 2018/3/24.
//  Copyright © 2018 Zihang Zhang. All rights reserved.
//

import Foundation
import SwiftHTTP

struct Utils {
    static let FILE_DIR = NSHomeDirectory() + "/Documents"
    
    static let FILE_MANAGER = FileManager.default
    
    static func refreshFile (resource: String, type: String, overwrite: Bool = false) {
        let fileManager = FileManager.default
        let filePath = "\(Utils.FILE_DIR)/\(resource).\(type)"
        let originalPath = Bundle.main.path(forResource: resource, ofType: type)
        let exist = Utils.FILE_MANAGER.fileExists(atPath: filePath)
        if exist == true {
            if overwrite == true {
                Utils.removeFile(resource: resource, type: type)
            } else {
                print("\(resource).\(type) exists.")
                return
            }
        }
        try! fileManager.copyItem(atPath: originalPath!, toPath: filePath)
        print("\(resource).\(type) saved.")
    }
    
    static func removeFile (resource: String, type: String) {
        let filePath = "\(Utils.FILE_DIR)/\(resource).\(type)"
        try! Utils.FILE_MANAGER.removeItem(atPath: filePath)
        print("previous \(resource).\(type) removed.")
    }
    
    static func refreshViewFiles () {
        Utils.refreshFile(resource: "index", type: "html", overwrite: true)
        Utils.refreshFile(resource: "bundle", type: "js")
        Utils.refreshFile(resource: "userdata", type: "plist")
    }
    
    static func getDataJson () {
        let username = Utils.getUsername()
        HTTP.GET("https://github.com/\(username)") { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return
            }
            let url = NSURL(fileURLWithPath: "\(Utils.FILE_DIR)/data.json")
            let data = NSMutableData()
            data.append(NSData(data: response.description.data(using: String.Encoding.utf8, allowLossyConversion: true)!) as Data)
            data.write(toFile: url.path!, atomically: true)
            print("data.json saved. current user: \(username)")
        }
    }
    
    static func getUsername () -> String {
        let userDataDict: NSDictionary? = NSDictionary(contentsOfFile: "\(Utils.FILE_DIR)/userdata.plist")
        return userDataDict!["username"]! as! String
    }
    
    static func setUsername (username: String) {
        let newUserDataDict: NSDictionary = ["username": username]
        newUserDataDict.write(toFile: "\(Utils.FILE_DIR)/userdata.plist", atomically: true)
        print("data submitted: new user: \(username)")
        Utils.getDataJson()
    }
}
