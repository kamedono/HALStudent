//
//  MoodleInfo.swift
//  NewHALTitle
//
//  Created by Toshiki Higaki on 2015/09/14.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

/**
各コースにあるクリッカーのタイトルと選択肢の構造体
*/
struct ClickerSubject {
    var origneTitle: String
    var title: String
    var answerList: [String]
    var clickerDBID: String
    
    init() {
        self.origneTitle = ""
        self.title = ""
        self.answerList = []
        self.clickerDBID = ""
    }
}

/**
各コースにあるクリッカーの構造体
*/
struct ClickerContent {
    var clickerDBURL: String
    var clickerDBName: String
    var clickerDBID: String
    var clickerSubjectList: [ClickerSubject]
    
    init() {
        self.clickerDBURL = ""
        self.clickerDBName = ""
        self.clickerDBID = ""
        self.clickerSubjectList = []
    }
    
    init(url: String, name: String, id: String) {
        self.clickerDBURL = url
        self.clickerDBName = name
        self.clickerDBID = id
        self.clickerSubjectList = []
    }
}

/**
*各コース（XMLの問題集）の構造体
*/
struct QuizInfo {
    var quizName: String
    var quizURL: String
    
    init(name: String, url: String) {
        self.quizName = name
        self.quizURL = url
    }
    
    init(){
        self.quizName = ""
        self.quizURL = ""
    }
}


/**
*各コース（XMLの問題集）の構造体
*/
struct CourceContent {
    var courceName: String
    var courceNumber: String
    var courceURL: String
    var studentList: [String]
    var quizInfoList: [QuizInfo]
    // コースに登録されているクリッカーの情報リスト
    var clickerContentList: [ClickerContent]
    
    init(name: String, number: String, url: String) {
        self.courceName = name
        self.courceNumber = number
        self.courceURL = url
        self.studentList = []
        self.quizInfoList = []
        self.clickerContentList = []
    }
    
    init(){
        self.courceName = ""
        self.courceNumber = ""
        self.courceURL = ""
        self.studentList = []
        self.quizInfoList = []
        self.clickerContentList = []
    }
    
}

class MoodleInfo: NSObject {
    
    static var moodleInfoInstance = MoodleInfo()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //構造体の宣言
    var moodleURL: String? {
        get { return defaults.stringForKey("moodleURL") ?? "" }
        set { defaults.setObject(newValue, forKey: "moodleURL") }
    }
    
    //マイプロファイルのURL
    var myProfileURL: String? {
        get { return defaults.stringForKey("myProfileURL") ?? "" }
        set { defaults.setObject(newValue, forKey: "myProfileURL") }
    }
    
    //マイプロファイル編集ページのURL
    var editMyProfileURL: String? {
        get { return defaults.stringForKey("editMyProfileURL") ?? "" }
        set { defaults.setObject(newValue, forKey: "editMyProfileURL") }
    }
    
    //マイプロファイル編集ページのURL
    var profileImageURL: String? {
        get { return defaults.stringForKey("profileImageURL") ?? "" }
        set { defaults.setObject(newValue, forKey: "profileImageURL") }
    }
    // コースを保存する配列
    var courceList: [CourceContent] = []
    
    // コースを保存する配列
    var selectCourceList: [CourceContent] = []
    
    override init(){
        
        self.courceList = []
        
    }
}