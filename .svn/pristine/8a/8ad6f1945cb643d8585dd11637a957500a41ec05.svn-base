//
//  MoodleAccess.swift
//  NewHALTitle
//
//  Created by Toshiki Higaki on 2015/09/13.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

@objc protocol StudentMoodleAccessDelegate {
    /**
    アクセスした結果
    */
    optional func accessCheckResult(result: Bool)
    
    /**
    二回目移行のアクセスした結果
    */
    optional func accessCheckResultSecondTime(result: Bool)
    
    /**
    ログインした結果
    */
    optional func loginResult(result: Bool)
    
    /**
    コースの情報取得結果
    */
    optional func myProfileResult(result: Bool)
    
    /**
    コースの問題情報得後
    */
    optional func getEditMyProfile()
    
    /**
    画像取得後
    */
    optional func getMyProfileImage()
}

class StudentMoodleAccess : NSObject{
    
    var delegate: StudentMoodleAccessDelegate!
    
    let httpRegex = "http://"
    
    var userID: String = ""
    var password: String = ""
    var name: String = ""
    var number: String = ""
    var imageData: NSData?
    
    var moodleURL: String?
    var logoutURL: String = ""
    var myProfileURL: String = ""
    var editMyProfileURL: String = ""
    var profileImageURL: String = ""
    
    var userIDNumber = ""
    
    
    /**
    moodleログインページから情報を取得
    
    :param: url:MoodelのURL
    */
    func checkMoodleAccess(url:String) {
        
        //アクセスするURL(moodleログインページ)
        let deleteTarget = NSCharacterSet.whitespaceCharacterSet
        let urlString = url.stringByTrimmingCharactersInSet(deleteTarget())
        var url = NSURL(string: urlString)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {
            (data, resp, err) in
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            let regexPageNotFoound = "<title>404 Not Found</title>"
            let regexPageMoodlePage = "moodle/login/index.php"
            //404じゃないとき
            if(htmlSource != "" && htmlSource!.rangeOfString(regexPageNotFoound).length == 0 && htmlSource!.rangeOfString(regexPageMoodlePage).length != 0) {
                self.moodleURL = urlString
                self.delegate?.accessCheckResult?(true)
            }
            else {
                self.delegate?.accessCheckResult?(false)
            }
        })
        task.resume()
        
    }
    
    
    /**
    二回目移行のmoodleログインページから情報を取得
    
    :param: url:MoodelのURL
    */
    func checkMoodleAccessSecondTime() {
        
        //アクセスするURL(moodleログインページ)
        //        let deleteTarget = NSCharacterSet.whitespaceCharacterSet
        //        let urlString = url.stringByTrimmingCharactersInSet(deleteTarget())
        var url = NSURL(string: MoodleInfo.moodleInfoInstance.moodleURL!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {
            (data, resp, err) in
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            let regexPageNotFoound = "<title>404 Not Found</title>"
            let regexPageMoodlePage = "moodle/login/index.php"
            //404じゃないとき
            if(htmlSource != "" && htmlSource!.rangeOfString(regexPageNotFoound).length == 0 && htmlSource!.rangeOfString(regexPageMoodlePage).length != 0) {
                self.delegate?.accessCheckResultSecondTime?(true)
            }
                
            else {
                self.delegate?.accessCheckResultSecondTime?(false)
            }
        })
        task.resume()
        
    }
    
    
    /**
    ログインのみを行う
    
    :param: userID:MoodelのURL
    :param: password:MoodelのURL
    */
    func moodleLogin(userID: String, password: String) {
        //アクセスするURL(moodleログインページ)
        let test = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL!) + "/login/"
        var url = NSURL(string: (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL!) + "/login/")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var request = NSMutableURLRequest(URL: url!)
        
        //マイプロファイルのURL
        var myProfileURL = ""
        
        request.HTTPMethod = "POST"
        request.HTTPBody = "username=\(userID)&password=\(password)".dataUsingEncoding(NSUTF8StringEncoding)
        
        var task = session.dataTaskWithRequest(request, completionHandler: {
            (data, resp, err) in
            
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            let regexPageNotFoound = "<title>404 Not Found</title>"
            let regexPageMoodlePage = "あなたはログインしていません。"
            if (htmlSource != "" && htmlSource!.rangeOfString(regexPageNotFoound).length == 0 && htmlSource!.rangeOfString(regexPageMoodlePage).length == 0) {
                
                //ユーザ名の取得
                let headRegexUserName = "<div class=\"logininfo\">"
                let tailRegexUserName = "</a>"
                //キャストではダメ。NSMutableStringにappendStringしないと！
                
                //文字列の抽出ができるクラス変数（NSMutableString）
                var regexHTMLSource :NSMutableString = ""
                regexHTMLSource.appendString(String(htmlSource!))
                
                //抽出結果を格納する変数
                var tailRegex :NSString = ""
                
                //検索文字以降の文字列を取得
                var userInfo = regexHTMLSource.substringFromIndex(htmlSource!.rangeOfString(headRegexUserName).location + count(headRegexUserName))
                
                //検索文字より前の文字列を取得
                userInfo = (userInfo as NSString).substringToIndex((userInfo as NSString).rangeOfString(tailRegexUserName).location)
                userInfo = (userInfo as NSString).substringFromIndex((userInfo as NSString).rangeOfString("http://").location)
                var userName = (userInfo as NSString).substringFromIndex((userInfo as NSString).rangeOfString(">", options:NSStringCompareOptions.BackwardsSearch).location + 1)
                
                println("User Name : \(userName)")
                
                //ユーザのプロファイルURL
                myProfileURL = (userInfo as NSString).substringToIndex((userInfo as NSString).rangeOfString("\"").location)
                println("My Profile URL : \(myProfileURL)")
                
                //出席番号
                var userNumber = ""
                let regexUserNumber = "/user/profile.php?id="
                
                
                
                //ログイン成功判定
                if((myProfileURL as NSString).rangeOfString(regexUserNumber).length == 0) {
                    //ログイン失敗した時
                    self.delegate?.loginResult?(false)
                    
                }else{
                    self.delegate?.loginResult?(true)
                }
            }
            else {
                self.delegate?.loginResult?(false)
            }
        })
        task.resume()
    }
    
    
    /**
    ログインの結果を返す
    
    :param: userID:MoodelのURL
    :param: password:MoodelのURL
    */
    func checkMoodleLogin(userID:String, password:String) {
        //アクセスするURL(moodleログインページ)
        var url = NSURL(string: (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL!) + "/login/")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var request = NSMutableURLRequest(URL: url!)
        
        //マイプロファイルのURL
        var myProfileURL = ""
        
        request.HTTPMethod = "POST"
        request.HTTPBody = "username=\(userID)&password=\(password)".dataUsingEncoding(NSUTF8StringEncoding)
        
        var task = session.dataTaskWithRequest(request, completionHandler: {
            (data, resp, err) in
            
            //htmlページのソースコード
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            let regexPageNotFoound = "<title>404 Not Found</title>"
            let regexPageMoodlePage = "あなたはログインしていません。"
            if (htmlSource != "" && htmlSource!.rangeOfString(regexPageNotFoound).length == 0 && htmlSource!.rangeOfString(regexPageMoodlePage).length == 0) {
                
                //ユーザ名の取得
                let headRegexUserName = "<div class=\"logininfo\">"
                let tailRegexUserName = "</a>"
                //キャストではダメ。NSMutableStringにappendStringしないと！
                
                //文字列の抽出ができるクラス変数（NSMutableString）
                var regexHTMLSource :NSMutableString = ""
                regexHTMLSource.appendString(String(htmlSource!))
                
                //抽出結果を格納する変数
                var tailRegex :NSString = ""
                
                //検索文字以降の文字列を取得
                var userInfo = regexHTMLSource.substringFromIndex(htmlSource!.rangeOfString(headRegexUserName).location + count(headRegexUserName))
                
                //検索文字より前の文字列を取得
                userInfo = (userInfo as NSString).substringToIndex((userInfo as NSString).rangeOfString(tailRegexUserName).location)
                userInfo = (userInfo as NSString).substringFromIndex((userInfo as NSString).rangeOfString("http://").location)
                var userName = (userInfo as NSString).substringFromIndex((userInfo as NSString).rangeOfString(">", options:NSStringCompareOptions.BackwardsSearch).location + 1)
                
                println("User Name : \(userName)")
                
                //ユーザのプロファイルURL
                myProfileURL = (userInfo as NSString).substringToIndex((userInfo as NSString).rangeOfString("\"").location)
                println("My Profile URL : \(myProfileURL)")
                
                //出席番号
                var userNumber = ""
                let regexUserNumber = "/user/profile.php?id="
                
                //ログイン成功判定
                if((myProfileURL as NSString).rangeOfString(regexUserNumber).length == 0) {
                    //ログイン失敗した時
                    self.delegate?.loginResult?(false)
                    
                }else{
                    //出席番号
                    userNumber = (myProfileURL as NSString).substringFromIndex((myProfileURL as NSString).rangeOfString(regexUserNumber).location + count(regexUserNumber))
                    println("出席番号： \(userNumber)")
                    
                    var courceList: [CourceContent] = []
                    
                    let headRegexMoodleLogout = "/login/logout.php?"
                    let tailRegexMoodleLogout = "\">"
                    
                    // ログアウトのURLを取得
                    var logoutURL: String = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexMoodleLogout).location)
                    logoutURL = (logoutURL as NSString).substringToIndex((logoutURL as NSString).rangeOfString(tailRegexMoodleLogout).location)
                    
                    
                    self.logoutURL = logoutURL
                    self.myProfileURL = myProfileURL
                    
                    self.number = userNumber
                    self.name = userName
                    self.userID = userID
                    self.password = password
                    
                    self.delegate?.loginResult?(true)
                }
            }
            else {
                self.delegate?.loginResult?(false)
            }
        })
        task.resume()
    }
    
    
    
    /**
    マイプロファイルから情報を取得
    
    :param: url:MoodelのURL
    */
    func getMyProfile(){
        var url = NSURL(string: self.myProfileURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            //プロファイルから画像URLを取得
            let headRegexImageTag = "<div class=\"profilepicture\">"
            let headRegexImageURL = "<img src=\""
            if(htmlSource!.rangeOfString(headRegexImageTag).length != 0){
                var profileTag = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(headRegexImageTag).location + count(headRegexImageTag))
                profileTag = (profileTag as NSString).substringFromIndex((profileTag as NSString).rangeOfString(headRegexImageURL).location + count(headRegexImageURL))
                self.profileImageURL = (profileTag as NSString) .substringToIndex((profileTag as NSString).rangeOfString("\"").location)
                println("画像の URL :\(self.profileImageURL)")
            }
            
            //プロファイルを編集ページのURL取得
            let regexMyProfileURL = "/user/edit.php"
            //adminユーザはURLが異なるため分岐処理
            if(htmlSource!.rangeOfString(regexMyProfileURL).length != 0){
                //admin以外の場合
                var editMyProfileInfo = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(regexMyProfileURL).location)
                editMyProfileInfo = (editMyProfileInfo as NSString).substringToIndex((editMyProfileInfo as NSString).rangeOfString("\">").location)
                //                self.editMyProfileURL = self.localhost + "moodle" + editMyProfileInfo
                self.editMyProfileURL = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL!) + editMyProfileInfo
                println("プロファイル編集ページのURL： \(self.editMyProfileURL)")
                self.delegate?.myProfileResult?(true)
            }else{
                //adminユーザの場合
                self.delegate?.myProfileResult?(false)
            }
        })
        task.resume()
    }
    
    
    /**
    IDナンバーの取得を行う
    */
    func getEditMyProfile(){
        var url = NSURL(string: self.editMyProfileURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            var htmlSource = NSString(data: data, encoding: NSUTF8StringEncoding)
            //IDナンバーのvalueを取得する
            let regexMyProfile = "id=\"fitem_id_idnumber\""
            let regexMyProfileTail = "id=\"id_idnumber\""
            
            var userIDNumberInfo = htmlSource!.substringFromIndex(htmlSource!.rangeOfString(regexMyProfile).location + count(regexMyProfile))
            userIDNumberInfo = (userIDNumberInfo as NSString).substringFromIndex((userIDNumberInfo as NSString).rangeOfString("value=").location)
            userIDNumberInfo = (userIDNumberInfo as NSString).substringToIndex((userIDNumberInfo as NSString).rangeOfString(regexMyProfileTail).location)
            userIDNumberInfo = (userIDNumberInfo as NSString).substringFromIndex((userIDNumberInfo as NSString).rangeOfString("\"").location + 1)
            userIDNumberInfo = (userIDNumberInfo as NSString).substringToIndex((userIDNumberInfo as NSString).rangeOfString("\"").location)
            self.userIDNumber = userIDNumberInfo
            println(userIDNumberInfo)
            
            self.delegate?.getEditMyProfile?()
        })
        
        task.resume()
    }
    
    
    /**
    画像の取得を行う
    */
    func getMyProfileImage(){
        var url = NSURL(string: self.profileImageURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        req.HTTPMethod = "POST"
        var task = session.dataTaskWithRequest(req, completionHandler: {
            (data, resp, err) in
            self.imageData = data
            
            self.delegate?.getMyProfileImage?()
        })
        
        task.resume()
    }
    
    
    /**
    ログアウト
    */
    func logout(){
        var url = NSURL(string: (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL!) + self.logoutURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        var req = NSMutableURLRequest(URL: url!)
        var task = session.dataTaskWithRequest(req)
        task.resume()
        
    }
    
    /**
    データをuserDefaultに保存
    */
    func setMoodleInfo() {
        
        StudentInfo.studentInfoInstance.setInfo(self.userID, password: self.password, name: self.name, number: self.number, imageData: self.imageData!)
        
        MoodleInfo.moodleInfoInstance.moodleURL = (self.moodleURL ?? MoodleInfo.moodleInfoInstance.moodleURL!)
        MoodleInfo.moodleInfoInstance.myProfileURL = self.myProfileURL
        MoodleInfo.moodleInfoInstance.editMyProfileURL = self.editMyProfileURL
        MoodleInfo.moodleInfoInstance.profileImageURL = self.profileImageURL
        //        MoodleData.moodleDataInstance.userIDNumber = self.userIDNumber
        
    }
}