//
//  File.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/26.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class ClickerSimpleViewController: UIViewController, FinishFunctionDelegate, CorePeripheralManagerDelegate {
    // 解答ボタンの画像の色リスト
    let buttonColorList: [String] = ["#ff1e1e", "#f39800", "#ffff28", "#adff2f", "#00ff00", "#00bfff", "#0000cd", "#962dff"]
    let buttonTitleList: [String] = ["A", "B", "C", "D", "E", "F", "G", "H"]
    
    var imgSetFlag :Bool = false
    var questionNumber: Int = 0
    
    enum ToucheCount {
        case zero
        case farst
        case second
    }
    
    var toucheCount: ToucheCount = .zero
    
    //問題情報
    var question: QuestionXML!
    
    var firstFlag = false
    
    
    //問題の回数呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        // 戻る禁止
        self.navigationItem.setHidesBackButton(true, animated: true)

        // 画面サイズを取得 Windowの表示領域すべてのサイズ(point).
        let boundsFrameSize: CGSize = self.view.bounds.size
        
        // 高度な計算
        let yPoint = Int(boundsFrameSize.height - 200)
        
        // 解答数
        let count = ClickerInfo.clickerInfoInstance.answerNumber
        
        let barSize = 64
        
        // ボタンを生成！
        for (var i=1; i <= count; i++){
            
            // 案1
            // viewの一つあたりのサイズ
            var height = CGFloat((Int(boundsFrameSize.height)-barSize) / ((count! + 1) / 2))
            var width = CGFloat(Int(boundsFrameSize.width)/2)
            
            let startYPoint = CGFloat(Int(height) * ((i + 1) / 2 - 1) + barSize)
            var startXPoint: CGFloat!
            
            // 偶数個目、奇数個目で処理をわける
            switch (i % 2){
            case 0:
                startXPoint = CGFloat(Int(boundsFrameSize.width) / 2)
                
            case 1:
                startXPoint = CGFloat(Int(boundsFrameSize.width) / 2) - width
                
            default:
                break
            }
            
            // 回答群が奇数個の時
            if i == count && count! % 2 == 1 {
                startXPoint = width / 2
            }
            
            // コードから初期化
            let answerButton = UIButton(frame: CGRectMake(startXPoint, startYPoint, width, height))
            
            // 解答ボタンの画像の設定
            //            let buttonImage = UIImage(named: self.buttonImageList[i-1])
            //            answerButton.setImage(buttonImage, forState: UIControlState.Normal)
            
            answerButton.backgroundColor = UIColor.hexStr(self.buttonColorList[i-1], alpha: 1)
            answerButton.tag = i-1
            answerButton.setTitle(self.buttonTitleList[i-1], forState: UIControlState.Normal)
            // フォントの自動調節
            answerButton.titleLabel?.font = UIFont.systemFontOfSize(150)
            answerButton.titleLabel?.adjustsFontSizeToFitWidth = true
            answerButton.titleLabel!.lineBreakMode = NSLineBreakMode.ByClipping
            
            // アクションの設定
            answerButton.addTarget(self, action: "pushButton:", forControlEvents: .TouchUpInside)
            
            self.view.addSubview(answerButton)
            
            //            // 案２
            //            var putType = count / 2
            //            // viewの一つあたりのサイズ
            //            var buttonHeight = CGFloat((Int(boundsFrameSize.height) - barSize) / 2)
            //            var buttonWidth = CGFloat(Int(boundsFrameSize.width) / (putType + count % 2))
            //            var startYPoint: CGFloat!
            //            var startXPoint = CGFloat(Int(buttonWidth) * ((i-1) % putType))
            //
            //            if buttonHeight < buttonWidth {
            //                buttonWidth = buttonHeight
            //            }
            //
            //            else {
            //                buttonHeight = buttonWidth
            //            }
            //
            //            let halfByttonWidth = buttonWidth / 2
            //            let halfByttonHeight = buttonHeight / 2
            //
            //            let blank = CGFloat((Int(boundsFrameSize.width) - ((Int(buttonWidth) * (count / 2 + count % 2)))) / 2)
            //
            //            // 中央で分ける処理　上
            //            if ((i-1) / putType) == 0 {
            //                startYPoint = CGFloat(Int(boundsFrameSize.height)) - buttonHeight * 2
            //                // 奇数の時
            //                if count % 2 == 1 {
            //                    startXPoint = CGFloat(Int(blank) + Int(halfByttonWidth) + ((i-1) * Int(buttonWidth)))
            //                }
            //                    // 偶数
            //                else {
            //                    startXPoint = blank + (CGFloat((i-1) % putType) * buttonWidth)
            //                }
            //            }
            //                // 中央で分ける処理　下
            //            else {
            //                startXPoint = blank + (CGFloat((i-1) - putType) * buttonWidth)
            //                startYPoint = CGFloat(Int(boundsFrameSize.height)) - buttonHeight
            //            }
            //
            //            // コードから初期化
            //            let answerButton = UIButton(frame: CGRectMake(startXPoint, startYPoint, buttonWidth, buttonHeight))
            //
            //            // 解答ボタンの画像の設定
            //            let buttonImage = UIImage(named: self.buttonImageList[i-1])
            //
            //            answerButton.setImage(buttonImage, forState: UIControlState.Normal)
            //            answerButton.tag = i-1
            //
            //            // アクションの設定
            //            answerButton.addTarget(self, action: "pushButton:", forControlEvents: .TouchUpInside)
            //
            //            self.view.addSubview(answerButton)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        CorePeripheralManager.corePeripheralInstance.delegate = self
    }
    
    //画像付き問題の処理　HTMLタグの削除
    func imgSetter(questionText:String) ->String{
        var text = questionText
        //<imgより前の文字を取得
        var parsedArrHead = text.componentsSeparatedByString("<img")
        text = parsedArrHead[0]
        //">より前の文字を消す
        var parsedArrHip = parsedArrHead[1].componentsSeparatedByString("\">")
        text += parsedArrHip[1]
        
        return text
    }
    
    // ボタンが押された時の処理
    func pushButton(sender: UIButton) {
        var mark = ""
        switch(sender.tag) {
        case 0:
            mark = "A"
        case 1:
            mark = "B"
        case 2:
            mark = "C"
        case 3:
            mark = "D"
        case 4:
            mark = "E"
        case 5:
            mark = "F"
        case 6:
            mark = "G"
        case 7:
            mark = "H"
            
        default:
            println("default")
        }
        
        switch(self.toucheCount) {
        case .zero:
            self.toucheCount = .farst
            
            ClickerInfo.clickerInfoInstance.selectMark = mark
            CorePeripheralManager.corePeripheralInstance.notification(CorePeripheralManager.corePeripheralInstance.clickerUUID, sendData: nil)
        case .farst:
            dispatch_async(dispatch_get_main_queue(), {
                // AlertController作成
                var downloadingAlertView = UIAlertController(title: "解答を変更しますか？", message: "これ以上解答を変更できません", preferredStyle: .Alert)
                
                // わかったボタン
                var acceptAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    self.toucheCount = .second
                    ClickerInfo.clickerInfoInstance.selectMark = mark
                    CorePeripheralManager.corePeripheralInstance.notification(CorePeripheralManager.corePeripheralInstance.clickerUUID, sendData: nil)
                    
                }
                var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                }
                // AlertControllerにindicatorを追加させる
                downloadingAlertView.addAction(acceptAction)
                downloadingAlertView.addAction(cancelAction)
                self.presentViewController(downloadingAlertView, animated: true, completion: nil)
            })
        case .second:
            println("out")
        }
        
    }

    
    
    
    // ----Delegate宣言----
    
    
    
    /**
    結果画面に行って欲しいときに通知されるデリゲート
    */
    func goNextViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
    
    /**
    クリッカー終了通知のデリゲート
    */
    func clickerFinish(status: String?) {
        if status == "stop" {
            self.view.userInteractionEnabled = false
        }
        else if status == "finish" {
            self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
        }
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
    
}