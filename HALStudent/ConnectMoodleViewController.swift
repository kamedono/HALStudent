//
//  ConnectTeacherViewController.swift
//  Student
//
//  Created by Toshiki Higaki on 2015/08/03.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import CoreBluetooth


class ConnectMoodleViewController: UIViewController, CorePeripheralManagerDelegate, StudentMoodleLoginAlertDelegate {
    
    // プロフィールのビュー
    @IBOutlet weak var moodleProfileView: UIView!
    @IBOutlet weak var moodleProfileImage: UIImageView!
    @IBOutlet weak var moodleProfileName: UILabel!
    
    
    @IBOutlet weak var stateLabel: UILabel!
    
    var discoverTeacherList: [String!] = []
    
    var studentMoodleLoginAlert = StudentMoodleLoginAlert()
    var studentMoodleAccess = StudentMoodleAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ビューを隠す
        self.moodleProfileView.hidden = true
        
        // 画像を丸く
        self.moodleProfileImage.layer.cornerRadius = self.moodleProfileImage.frame.width / 2
        self.moodleProfileImage.layer.masksToBounds = true
        
        self.title = "Moodleログイン"
        
        self.stateLabel.text = "ログイン作業を行いましょう。"

        self.navigationController!.navigationBar.barTintColor = UIColor.navigationColor()

        self.studentMoodleLoginAlert.delegate = self
        self.studentMoodleAccess.delegate = self.studentMoodleLoginAlert
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if StudentInfo.studentInfoInstance.userID == nil || StudentInfo.studentInfoInstance.password == nil || MoodleInfo.moodleInfoInstance.moodleURL == nil {
            self.studentMoodleLoginAlert.createMoodleAccessCheckAlert()
        }
        else {
            self.studentMoodleLoginAlert.moodleAccess = self.studentMoodleAccess
            self.studentMoodleLoginAlert.createMoodleAccessAlertView()
            self.studentMoodleAccess.checkMoodleAccessSecondTime()
            
        }
    }
    
    /**
    ページ遷移をする際に呼ばれるメソッド
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "quesionPrepareForSegue") {
        }
    }
    
    /**
    ユーザ変更ボタン
    */
    @IBAction func userChangeButtonAction(sender: AnyObject) {
        self.studentMoodleLoginAlert.createMoodleAccessCheckAlertEnableCancel()
    }
    
    /**
    ユーザ決定ボタン
    */
    @IBAction func userSelectButtonAction(sender: AnyObject) {
        self.createFailAlertView()
    }
    
    /**
    失敗時のAlert表示
    */
    func createFailAlertView() {
        // AlertController作成
        var moodleAccessAlertView = UIAlertController(title: "ユーザを決定します", message: "授業中の変更はできません\nよろしいですか？", preferredStyle: .Alert)
        
        // OKボタンを押した時
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("goWaitViewControllerSegue", sender: nil)
        }

        // キャンセルボタンを押した時
        var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        // Add the actions
        moodleAccessAlertView.addAction(okAction)
        moodleAccessAlertView.addAction(cancelAction)
        
        //Viewを見せる
        self.presentViewController(moodleAccessAlertView, animated: true, completion: nil)
    }
    
    
    
    
    // ----Delegate宣言----
    

    /**
    接続終了時
    */
    func connectionFinished() {
        dispatch_async(dispatch_get_main_queue(), {
            self.title = "ようこそ \(StudentInfo.studentInfoInstance.name!)さん"
            
            self.moodleProfileImage.image = UIImage(data: StudentInfo.studentInfoInstance.imageData!)
            self.moodleProfileName.text = StudentInfo.studentInfoInstance.name
            self.moodleProfileView.hidden = false
        })
    }
}