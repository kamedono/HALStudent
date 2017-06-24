//
//  AlertViewPresentFunction.swift
//  NewHALTitle
//
//  Created by Toshiki Higaki on 2015/09/11.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

@objc protocol StudentMoodleLoginAlertDelegate {
    /**
    moodleから情報を取得し終えた時のデリゲート
    */
    optional func connectionFinished()
    
}

class StudentMoodleLoginAlert : NSObject , StudentMoodleAccessDelegate {
    var moodleURL: String
    
    var delegate: StudentMoodleLoginAlertDelegate?
    
    // webスクレイピングを行うファンクション
    var moodleAccess: StudentMoodleAccess?
    
    
    // 現在のViewControllerを取得
    var topViewController: UIViewController! {
        get {
            return getTopViewController()
        }
    }
    
    //ダウンロード完了時のalertView
    var moodleLoginAlertView :UIAlertController!
    
    //ダウンロード完了時のalertView
    var downloadedAlertView :UIAlertController!
    
    //ダウンロード中のalertView
    var downloadingAlertView :UIAlertController!
    
    // ログイン情報を入力するのalertView
    var inputAlertView :UIAlertController!
    
    // アクセス最中のalertView
    var moodleAccessAlertView :UIAlertController!
    
    override init() {
        // userDefoultから取得します
        self.moodleURL = MoodleInfo.moodleInfoInstance.moodleURL!
    }
    
    
    /**
    moodleアクセスのURLを入力し、アクセスするAlert表示
    */
    func createMoodleAccessCheckAlert() {
        var moodleURLTextField: UITextField?
        self.moodleAccess = StudentMoodleAccess()
        
        // デリゲート設定
        self.moodleAccess!.delegate = self
        
        dispatch_async(dispatch_get_main_queue(), {
            //AlertController作成
            self.moodleLoginAlertView = UIAlertController(title: "moodleアクセス画面", message: "moodleのURLを入力して下さい", preferredStyle: .Alert)
            //アクセスボタンを押した時
            var accessAction = UIAlertAction(title: "アクセス", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                self.moodleURL = moodleURLTextField!.text
                
                // 空白削除
                let deleteTarget = NSCharacterSet.whitespaceCharacterSet
                self.moodleURL.stringByTrimmingCharactersInSet(deleteTarget())
                println("入力した文字\((self.moodleURL as String))")
                
                // URLにアクセス
                self.moodleAccess!.checkMoodleAccess(self.moodleURL)
                
            }
            
            // Add the actions
            self.moodleLoginAlertView.addAction(accessAction)
            self.moodleLoginAlertView.addTextFieldWithConfigurationHandler {textField -> Void in
                textField.placeholder = "moodleURL"
                moodleURLTextField = textField
//                moodleURLTextField?.text = "http://10.0.0.222/moodle/"
//                moodleURLTextField?.text = "http://192.168.113.234/moodle/"
                moodleURLTextField?.text = "http://160.245.62.234/moodle/"
            }
            
            self.topViewController.presentViewController(self.moodleLoginAlertView, animated: true, completion: nil)
        })
        
    }
    
    /**
    moodleアクセスのURLを入力し、アクセスするAlert表示
    */
    func createMoodleAccessCheckAlertEnableCancel() {
        var moodleURLTextField: UITextField?
        self.moodleAccess = StudentMoodleAccess()
        
        // デリゲート設定
        self.moodleAccess!.delegate = self
        
        dispatch_async(dispatch_get_main_queue(), {
            //AlertController作成
            self.moodleLoginAlertView = UIAlertController(title: "moodleアクセス画面", message: "moodleのURLを入力して下さい", preferredStyle: .Alert)
            //アクセスボタンを押した時
            var accessAction = UIAlertAction(title: "アクセス", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
                self.moodleURL = moodleURLTextField!.text
                
                // 空白削除
                let deleteTarget = NSCharacterSet.whitespaceCharacterSet
                self.moodleURL.stringByTrimmingCharactersInSet(deleteTarget())
                println("入力した文字\((self.moodleURL as String))")
                
                // URLにアクセス
                self.moodleAccess!.checkMoodleAccess(self.moodleURL)
                
            }
            
            //キャンセルボタンを押した時
            var chancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            
            // Add the actions
            self.moodleLoginAlertView.addAction(accessAction)
            self.moodleLoginAlertView.addAction(chancelAction)
            self.moodleLoginAlertView.addTextFieldWithConfigurationHandler {textField -> Void in
                textField.placeholder = "moodleURL"
                moodleURLTextField = textField
                moodleURLTextField?.text = "http://160.245.62.234/moodle/"
//                moodleURLTextField?.text = "http://192.168.113.234/moodle/"
//                moodleURLTextField?.text = "http://10.0.0.2/moodle/"
            }
            
            self.topViewController.presentViewController(self.moodleLoginAlertView, animated: true, completion: nil)
        })
        
    }
    
    
    /**
    moodleにログインするためのAlertを表示
    */
    func createMoodleLoginAlertView(){
        var moodleUserIDTextField: UITextField?
        var moodlePasswordTextField: UITextField?
        dispatch_async(dispatch_get_main_queue(), {
            //AlertController作成
            self.inputAlertView = UIAlertController(title: "moodleログイン画面", message: "ユーザIDとパスワードを入力して下さい", preferredStyle: .Alert)
            //ログインボタンを押した時
            var loginAction = UIAlertAction(title: "ログイン", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                let textFields:Array<UITextField>? =  self.inputAlertView.textFields as! Array<UITextField>?
                if textFields != nil {
                    
                    self.moodleAccess!.checkMoodleLogin(moodleUserIDTextField!.text!, password: moodlePasswordTextField!.text!)
                    
                    self.createMoodleAccessAlertView()
                }
                println()
            }
            //キャンセルボタンを押した時
            var chancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.createMoodleAccessCheckAlert()
            }
            self.inputAlertView.addAction(loginAction)
            self.inputAlertView.addAction(chancelAction)
            self.inputAlertView.addTextFieldWithConfigurationHandler({textField -> Void in
                textField.placeholder = "userID"
                
                moodleUserIDTextField = textField
                
                // 初期値入力（あとで消す
                //                moodleUserIDTextField!.text = StudentInfo.studentInfoInstance.userID
                moodleUserIDTextField!.text = "user1"
                
            })
            self.inputAlertView.addTextFieldWithConfigurationHandler({textField -> Void in
                textField.placeholder = "password"
                textField.secureTextEntry = true
                
                moodlePasswordTextField = textField
                
                // 初期値入力（あとで消す
                //                moodlePasswordTextField!.text = StudentInfo.studentInfoInstance.password
                moodlePasswordTextField!.text = "N@gaoLab2014"
                
            })
            self.topViewController.presentViewController(self.inputAlertView, animated: true, completion: nil)
        })
    }
    
    /**
    moodleにログインするためのAlertを表示
    */
    func createMoodleLoginAlertViewEnableCancel(){
        var moodleUserIDTextField: UITextField?
        var moodlePasswordTextField: UITextField?
        dispatch_async(dispatch_get_main_queue(), {
            //AlertController作成
            self.inputAlertView = UIAlertController(title: "moodleログイン画面", message: "ユーザIDとパスワードを入力して下さい", preferredStyle: .Alert)
            //ログインボタンを押した時
            var loginAction = UIAlertAction(title: "ログイン", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                let textFields:Array<UITextField>? =  self.inputAlertView.textFields as! Array<UITextField>?
                if textFields != nil {
                    
                    self.moodleAccess!.checkMoodleLogin(moodleUserIDTextField!.text!, password: moodlePasswordTextField!.text!)
                    
                    self.createMoodleAccessAlertView()
                }
                println()
            }
            //キャンセルボタンを押した時
            var chancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            self.inputAlertView.addAction(loginAction)
            self.inputAlertView.addAction(chancelAction)
            self.inputAlertView.addTextFieldWithConfigurationHandler({textField -> Void in
                textField.placeholder = "userID"
                
                moodleUserIDTextField = textField
                
                // 初期値入力（あとで消す
                //                moodleUserIDTextField!.text = StudentInfo.studentInfoInstance.userID
                moodleUserIDTextField!.text = "user"
                
            })
            self.inputAlertView.addTextFieldWithConfigurationHandler({textField -> Void in
                textField.placeholder = "password"
                textField.secureTextEntry = true
                
                moodlePasswordTextField = textField
                
                // 初期値入力（あとで消す
                //                moodlePasswordTextField!.text = StudentInfo.studentInfoInstance.password
                moodlePasswordTextField!.text = "N@gaoLab2014"
                
            })
            self.topViewController.presentViewController(self.inputAlertView, animated: true, completion: nil)
        })
    }
    
    /**
    moodleアクセス中のAlert表示
    */
    func createMoodleAccessAlertView() {
        dispatch_async(dispatch_get_main_queue(), {
            //AlertController作成
            self.downloadingAlertView = UIAlertController(title: "moodleアクセス中", message: "\n\n", preferredStyle: .Alert)
            var indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            //indicatorの位置決め
            indicator.center = CGPointMake(self.downloadingAlertView.view.bounds.height/6 ,self.downloadingAlertView.view.frame.size.width/15)
            //indicatorを回す
            indicator.startAnimating()
            
            //AlertControllerにindicatorを追加させる
            self.downloadingAlertView.view.addSubview(indicator)
            //Viewを見せる
            self.topViewController.presentViewController(self.downloadingAlertView, animated: true, completion: nil)
        })
    }
    
    
    /**
    失敗時のAlert表示
    */
    func createFailAlertView(errorMessage: String, nextAlert: String) {
        //AlertController作成
        var moodleAccessAlertView = UIAlertController(title: "エラーが発生しました", message: errorMessage, preferredStyle: .Alert)
        
        //OKボタンを押した時
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            switch(nextAlert) {
            case "moodleAccess":
                self.createMoodleAccessCheckAlert()
                
            case "input":
                self.createMoodleLoginAlertView()
                
            default:
                break
            }
        }
        
        // Add the actions
        moodleAccessAlertView.addAction(okAction)
        
        //Viewを見せる
        self.topViewController.presentViewController(moodleAccessAlertView, animated: true, completion: nil)
    }
    
    
    
    
    // ----Delegate宣言----
    
    /**
    初期起動時のアクセス結果のデリゲート
    */
    func accessCheckResult(result: Bool) {
        if result {
            //前のalertviewの削除
            self.createMoodleLoginAlertView()
        }
        else {
            self.createFailAlertView("Moodleの接続に失敗しました \n URLを確認してください",nextAlert: "moodleAccess")
        }
        
    }
    
    /**
    二回目移行のアクセス結果のデリゲート
    */
    func accessCheckResultSecondTime(result: Bool) {
        if result {

            self.moodleAccess!.checkMoodleLogin(StudentInfo.studentInfoInstance.userID!, password: StudentInfo.studentInfoInstance.password!)
        }
        else {
            var viewController = getTopMostController()
            if (viewController as? UIAlertController != nil) {
                viewController.dismissViewControllerAnimated(true, completion: nil)
            }
            self.createFailAlertView("Moodleの接続に失敗しました \n URLを確認してください",nextAlert: "moodleAccess")
        }
        
    }
    
    /**
    ログインした結果
    */
    func loginResult(result: Bool) {
        if result {
            //URLにアクセス
            self.moodleAccess!.getMyProfile()
            
        }
        else {
            var viewController = getTopMostController()
            if (viewController as? UIAlertController != nil) {
                viewController.dismissViewControllerAnimated(true, completion: nil)
            }
            self.createFailAlertView("Moodleのログインに失敗しました \n IDとPasswordを確認してください",nextAlert: "input")
        }
        
    }
    
    /**
    プロフィールのページ情報取得結果
    */
    func myProfileResult(result: Bool) {
        if result {
            //URLにアクセス
            self.moodleAccess!.getEditMyProfile()
        }
        else {
            self.moodleAccess!.logout()
            var viewController = getTopMostController()
            if (viewController as? UIAlertController != nil) {
                viewController.dismissViewControllerAnimated(true, completion: nil)
            }
            self.createFailAlertView("プロフィールの取得に失敗しました \n ログインユーザのID　\n　またはMoodleの設定を確認してください",nextAlert: "input")
        }
        
    }
    
    /**
    IDナンバー取得後
    */
    func getEditMyProfile() {
        // 画像の取得
        self.moodleAccess!.getMyProfileImage()
    }
    
    
    /**
    画像取得後
    */
    func getMyProfileImage() {
        self.moodleAccess!.setMoodleInfo()
        self.moodleAccess!.logout()
        self.moodleAccess = nil
        self.delegate?.connectionFinished?()
        
        //前のalertviewの削除
        var viewController = getTopMostController()
        if (viewController as? UIAlertController != nil) {
            viewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
}