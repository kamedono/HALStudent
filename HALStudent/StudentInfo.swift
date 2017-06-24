//
//  StudentInfo.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/08/07.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

class StudentInfo: NSObject{
    // todo coreDataからとって来ましょう
    static let studentInfoInstance = StudentInfo()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var userID: String? {
        get { return defaults.stringForKey("userID") }
        set { defaults.setObject(newValue, forKey: "userID") }
    }
    
    var password: String? {
        get { return defaults.stringForKey("password") }
        set { defaults.setObject(newValue, forKey: "password") }
    }
    
    var name: String? {
        get { return defaults.stringForKey("name") ?? "山本 愛"  }
        set { defaults.setObject(newValue, forKey: "name") }
    }
    
    var number: String? {
        get { return defaults.stringForKey("number") ?? ""  }
        set { defaults.setObject(newValue, forKey: "number") }
    }

    var imageData: NSData? {
        get { return defaults.objectForKey("image") as? NSData }
        set { defaults.setObject(newValue, forKey: "image") }
    }
    
    override init(){
        super.init()
        // todo coreDataからとって来ましょう
    }
    
    
    func setInfo(userID: String, password: String, name: String, number: String, imageData: NSData) {
        self.userID = userID
        self.password = password
        self.name = name
        self.number = number
        self.imageData = imageData
    }
    
    
    /**
    NSDataに変換する関数
    */
    func archiveNSData() -> NSData{
        var dataArray: [AnyObject] = []
        
        dataArray.append(self.userID!)
        dataArray.append(self.name!)
        dataArray.append(self.number!)
        dataArray.append(MoodleInfo.moodleInfoInstance.profileImageURL!)

        return NSKeyedArchiver.archivedDataWithRootObject(dataArray)
    }
    
}