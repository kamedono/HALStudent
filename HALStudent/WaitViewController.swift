//
//  FirstView.swift
//  Student
//
//  Created by sotuken on 2015/07/26.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//


import UIKit

class WaitViewController :UIViewController, XmlModuleDelegate, CorePeripheralManagerDelegate, StudentMoodleAccessDelegate {
    
    // 教員が選択したコンテンツの画像
    @IBOutlet weak var statusImage: UIImageView!
    
    // 教員が選択したコンテンツの画像
    @IBOutlet weak var statusLabel: UILabel!
    
    // タイトル戻るボタン！
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {}
    
    //問題データを格納する変数
    var Questions :QuestionBox!
    
    //デリゲートを呼ぶための宣言
    var xmlModule : XmlModule!
    
    // moodleにアクセスするためのなにか
    var studentMoodleAccess: StudentMoodleAccess!
    
    // moodleにアクセスするときのアラートを出すなにか
    var studentMoodleLoginAlert: StudentMoodleLoginAlert!
    
    //スクロールビューで表示するときにいる（問題数に合ったページを作るため）
    var sendMenus: Array<MenuElem> = []
    
    // url保存
    var url: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.xmlModule = XmlModule()
        self.xmlModule.delegate = self
        
        // moodleにアクセスするためのインスタンス生成
        self.studentMoodleAccess = StudentMoodleAccess()
        
        // ナビゲーションバーをつける
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        QuestionBox.questionBoxInstance.setEmpty()
        QuestionAnswerBox.questionAnswerBoxInstance.setEmpty()
        self.sendMenus = []
        
        // Bluetoothのデリゲート宣言
        CorePeripheralManager.corePeripheralInstance.delegate = self
        CorePeripheralManager.corePeripheralInstance.advertisementStart()
        
        // moodleのアクセス結果を得るためのデリゲート宣言
        self.studentMoodleAccess.delegate = self
        
        if CorePeripheralManager.corePeripheralInstance.centralList.count != 0 {
            self.statusLabel.text = "待機中です"
        }
        self.statusLabel.text = "教員の接続を待っています"
    }
    
    // ページ遷移をする際に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goSimpleViewSegue") {
            let simpleViewContoroller: SimpleViewController = segue.destinationViewController as! SimpleViewController
            simpleViewContoroller.menus = self.sendMenus
            
        }
        else if (segue.identifier == "goNominationSimpleViewSegue") {
            let simpleViewContoroller: NominationSimpleViewController = segue.destinationViewController as! NominationSimpleViewController
            simpleViewContoroller.menus = self.sendMenus
        }
    }
    
    
    /**
    失敗時のアラート
    */
    func failedAlert() {
        //AlertController作成
        var moodleAccessAlertView = UIAlertController(title: "ダウンロードに失敗しました。", message: "再度試してください。", preferredStyle: .Alert)
        
        //OKボタンを押した時
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        // Add the actions
        moodleAccessAlertView.addAction(okAction)
        
        //Viewを見せる
        self.presentViewController(moodleAccessAlertView, animated: true, completion: nil)
        
    }
    
    @IBAction func send(sender: AnyObject) {
        performSegueWithIdentifier("goClickerMoodleSomeViewSegue",sender: nil)
        
    }
    
    
    // ----Delegate宣言----
    
    
    /**
    教員端末と接続した時
    */
    func connectTeacher(){
        dispatch_async(dispatch_get_main_queue(), {
            self.statusLabel.text = "接続されました！\n待機中です"
        })
    }
    
    /**
    教員端末と接続が切れた時
    */
    func disconnectTeacher(){
        dispatch_async(dispatch_get_main_queue(), {
            self.statusLabel.text = "接続がきれました！\n教員の接続を待っています"
        })
    }
    
    /**
    XMLのパースが完了したら呼ばれるデリゲート
    menuElemに問題数分入力を追加
    */
    func finishRead() {
        let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
        dispatch_async(dispatch_get_main_queue(), {
            self.statusLabel.text = "準備完了！"
        })
        println("準備完了")
        
    }
    
    /**
    教員からのReady通知が来た時に呼ばれるデリゲート
    
    :param: updateCharacteristic 更新されたキャラクタリスティック
    */
    func quizReady(URL: String) {
        // メインスレッドで実行
        self.statusLabel.text = "問題のダウンロードを開始します！"
        
        // ログイン処理
        self.studentMoodleAccess.moodleLogin(StudentInfo.studentInfoInstance.userID!, password: StudentInfo.studentInfoInstance.password!)
        
        // url保存
        self.url = URL
    }
    
    /**
    教員からのStart通知が来た時に呼ばれるデリゲート
    
    :param: updateCharacteristic 更新されたキャラクタリスティック
    */
    func quizStart(type: String) {
        self.statusLabel.text = "スタート！！"
        
        //表示するリスト
        for var i=0; i < QuestionBox.questionBoxInstance.selectQuestion.count; i++ {
            var questionNum = "Q" + String(i+1)
            var Elem = MenuElem(name: questionNum, className: "SomeViewController", sbName: "Main", question: QuestionBox.questionBoxInstance.selectQuestion[i], num: i)
            sendMenus.append(Elem)
        }
        
        switch(type) {
        case "all":
            performSegueWithIdentifier("goSimpleViewSegue",sender: nil)
            
        case "nomination":
            performSegueWithIdentifier("goNominationSimpleViewSegue",sender: nil)
            
        default:
            performSegueWithIdentifier("goSimpleViewSegue",sender: nil)
        }
    }
    
    /**
    教員から選んだ問題の通知が来た時に呼ばれるデリゲート
    */
    func quizSelectQuestion(){
    }
    
    /**
    ダウンロードを失敗した時のデリゲート
    */
    func downloadFailed() {
        // アラート削除
        var viewController = getTopMostController()
        if (viewController as? UIAlertController != nil) {
            viewController.dismissViewControllerAnimated(true, completion: nil)
        }
        self.failedAlert()
        
    }
    
    /**
    ログインした時の結果を返すデリゲート
    */
    func loginResult(result: Bool){
        if result {
            // インスタンス化
            self.xmlModule = XmlModule()
            // デリゲート宣言
            self.xmlModule.delegate = self
            //ダウンロード・パース処理
            self.xmlModule.createQuestion(self.url)
        }
        else {
            // アラート削除
            var viewController = getTopMostController()
            if (viewController as? UIAlertController != nil) {
                viewController.dismissViewControllerAnimated(true, completion: nil)
            }
            self.failedAlert()
        }
    }
    
    /**
    クリッカーの時のデリゲート
    */
    func clickerStart(type: String) {
        if type == "nomal" {
            performSegueWithIdentifier("goClickerSimpleViewControllerSegue",sender: nil)
        }
        else {
            performSegueWithIdentifier("goClickerMoodleSomeViewSegue",sender: nil)
        }
    }
    
    /**
    選択コンテンツ通知の時のデリゲート
    */
    func selectContent(type: String) {
        switch(type) {
        case "QuizAll":
            self.statusImage.image = UIImage(named: "syoutestdefoSeleAllClear.png")
            self.statusLabel.text = "小テスト待機中です・・・"
            
        case "QuizNomination":
            self.statusImage.image = UIImage(named: "syoutestdefoSeleClear.png")
            self.statusLabel.text = "小テスト待機中です・・・\n指名されるかも？！"
            
        case "Clicker":
            self.statusImage.image = UIImage(named: "clickerClear.png")
            self.statusLabel.text = "クリッカー待機中です・・・"
            
        case "Web":
            //            self.statusImage.image = UIImage(named: "searchLearningClear.png")
            //            self.statusLabel.text = "調べ学習待機中です・・・"
            performSegueWithIdentifier("goWebViewControllerSegue",sender: nil)
            
        case "Wait":
            self.statusImage.image = UIImage(named: "syoutestdefoSeleAll.png")
            self.statusLabel.text = "待機中です"
            
        default:
            println("wait")
        }
    }
}
