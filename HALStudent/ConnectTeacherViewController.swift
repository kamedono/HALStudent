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
            self.studentMoodleAccess.checkMoodleLogin(StudentInfo.studentInfoInstance.userID!, password: StudentInfo.studentInfoInstance.password!)
            
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
    ユーザ変更ボタン
    */
    @IBAction func userSelectButtonAction(sender: AnyObject) {
        self.performSegueWithIdentifier("goQuesionPrepareForSegue", sender: nil)
    }
    
    // ----Delegate宣言----
    
    /**
    教員端末と接続した時
    */
    func connectTeacher(){
        dispatch_async(dispatch_get_main_queue(), {
            // ページの移動
//            self.performSegueWithIdentifier("quesionPrepareForSegue",sender: nil)
        })
    }
    
    /**
    接続終了時
    */
    func connectionFinished() {
        dispatch_async(dispatch_get_main_queue(), {
            self.title = "ようこそ \(StudentInfo.studentInfoInstance.name!)さん"
            
            self.moodleProfileImage.image = UIImage(data: StudentInfo.studentInfoInstance.imageData!)
            self.moodleProfileName.text = StudentInfo.studentInfoInstance.name
            self.moodleProfileView.hidden = false
            
            CorePeripheralManager.corePeripheralInstance.delegate = self
        })
    }
}