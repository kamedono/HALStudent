//
//  File.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/30.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class ClickerMoodleSomeViewController: UIViewController, AnswerViewDelegate, CorePeripheralManagerDelegate {
    // 解答ボタンの画像の色リスト
    var deepImageList: [String] = ["DeepRed.png", "DeepOrange.png", "DeepYellow.png", "DeepLightGreen.png", "DeepGreen.png", "DeepLightBlue.png", "DeepBlue.png", "DeepPurple.png"]
    
    var mark = ["A", "B", "C", "D", "E", "F", "G", "H"]
    var imgSetFlag :Bool = false
    var questionNumber:Int = 0
    
    enum ToucheCount {
        case zero
        case farst
        case second
    }
    
    //問題情報
    var question: QuestionXML!
    
    var firstFlag = false
    
    var toucheCount: ToucheCount = .zero
    
    var selectMark: String?
    
    //問題の回数呼ばれる
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // 画面サイズを取得 Windowの表示領域すべてのサイズ(point).
        let boundsFrameSize: CGSize = UIScreen.mainScreen().bounds.size
        
        // 問題数が入る
        let questionCount: Int = ClickerInfo.clickerInfoInstance.answerList!.count
        
        // 高度な計算
        let yPoint = Int(boundsFrameSize.height / 5 * 3 - 200)
        
        // ボタンを生成！
        for (var i=1; i <= questionCount; i++){
            // viewの一つあたりのサイズ
            let height = CGFloat((Int(boundsFrameSize.height) - yPoint - 100) / ((questionCount + 1) / 2))
            let width = CGFloat(Int(boundsFrameSize.width)/2)
            let startYPoint = CGFloat(yPoint + Int(height) * ((i + 1) / 2 - 1))
            var startXPoint: CGFloat!
            
            // 偶数個目、奇数個目で処理をわける
            switch (i % 2){
            case 0:
                startXPoint = width
                
            case 1:
                startXPoint = 0
                
            default:
                break
            }
            
            // 回答群が奇数個の時
            if i == questionCount && questionCount % 2 == 1 {
                startXPoint = width / 2
            }
            
            // コードから初期化
            let customView = AnswerView(frame: CGRectMake(startXPoint, startYPoint, width, height))
            
            //htmlタグの削除
            //            let questionText = htmlParse(question.answers[i-1].questionText)
            
            // 解答文とかセット！
            customView.answerLabel.font = UIFont.systemFontOfSize(30)
            customView.answerLabel.text = ClickerInfo.clickerInfoInstance.answerList![i-1]
            customView.answerSentenceLabel.text = self.mark[i-1]
            
            // 解答ボタンの画像の設定
            customView.setImage(deepImageList[i-1])
            
            // 初期化したインスタンスのdelegateを自身にセット
            customView.delegate = self
            
            // 問題などをセット。本当はもっと長い
            customView.number = i-1
            
            // フォントサイズ設定
            customView.setFontSize(questionCount)
            
            view.addSubview(customView)
        }
        
        let questionNumberLabel = UILabel()
        var questionTextLabel = UILabel()
        var questionTextLabelWidth = NSLayoutConstraint()
        
        //問題番号
        questionNumberLabel.frame = CGRectMake(10, 5, 50, 30)
        questionNumberLabel.font = UIFont.systemFontOfSize(30)
        questionNumberLabel.sizeToFit()
        
        questionTextLabel.text = ClickerInfo.clickerInfoInstance.questionText
        questionTextLabel.font = UIFont.systemFontOfSize(30)
        questionTextLabel.frame = CGRectMake(40, 90, 900, 5000)
        questionTextLabel.numberOfLines = 0
        questionTextLabel.sizeToFit()
        // フォントの自動調節
        questionTextLabel.adjustsFontSizeToFitWidth = true
        questionTextLabel.lineBreakMode = NSLineBreakMode.ByClipping
        
        var questionImageView:UIImageView = UIImageView()
        questionImageView.frame = CGRectMake(0, 50+questionTextLabel.bounds.height, questionImageView.bounds.width, questionImageView.bounds.height)
        
        //全体のサイズ
        self.view.addSubview(questionNumberLabel)
        self.view.addSubview(questionTextLabel)
        self.view.addSubview(questionImageView)
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
    
    
    
    
    
    // ----Delegate宣言----
    
    /**
    ボタンを押した時のデリゲート
    ボタンの色とかを変える
    
    :param: mark AとかBとか
    :param: num 問題の番号
    :param: answerData 解答のデータの構造体
    */
    func pushAnswerButton(mark: String, answerNumber: Int, answerData: String){
        switch(self.toucheCount) {
        case .zero:
            for view in self.view.subviews as! [UIView] {
                if let answerView = view as? AnswerView {
                    // タッチしたボタンかどうかの判定
                    if answerView.number != answerNumber {
                        ((view.subviews[0] as! UIView).subviews[1]as! UIView).backgroundColor = UIColor.whiteColor()
                    }
                    else {
                        ((view.subviews[0] as! UIView).subviews[1]as! UIView).backgroundColor = UIColor.clearColor()
                        ClickerInfo.clickerInfoInstance.selectMark = getMark(answerNumber)
                        
                        self.selectMark = getMark(answerNumber)
                        // 教員へ解答送信
                        CorePeripheralManager.corePeripheralInstance.notification(CorePeripheralManager.corePeripheralInstance.clickerUUID, sendData: nil)
                        
                        self.toucheCount = .farst
                    }
                }
            }
        case .farst:
            if self.selectMark != getMark(answerNumber) {
                dispatch_async(dispatch_get_main_queue(), {
                    // AlertController作成
                    var downloadingAlertView = UIAlertController(title: "解答を変更しますか？", message: "これ以上解答を変更できません", preferredStyle: .Alert)
                    
                    // わかったボタン
                    var acceptAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        for view in self.view.subviews as! [UIView] {
                            if let answerView = view as? AnswerView {
                                // タッチしたボタンかどうかの判定
                                if answerView.number != answerNumber {
                                    ((view.subviews[0] as! UIView).subviews[1]as! UIView).backgroundColor = UIColor.whiteColor()
                                }
                                else {
                                    ((view.subviews[0] as! UIView).subviews[1]as! UIView).backgroundColor = UIColor.clearColor()
                                    ClickerInfo.clickerInfoInstance.selectMark = getMark(answerNumber)
                                    
                                    self.selectMark = getMark(answerNumber)
                                    // 教員へ解答送信
                                    CorePeripheralManager.corePeripheralInstance.notification(CorePeripheralManager.corePeripheralInstance.clickerUUID, sendData: nil)
                                    
                                    self.toucheCount = .second
                                }
                            }
                        }
                    }
                    var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                    }
                    // AlertControllerにindicatorを追加させる
                    downloadingAlertView.addAction(acceptAction)
                    downloadingAlertView.addAction(cancelAction)
                    self.presentViewController(downloadingAlertView, animated: true, completion: nil)
                })
                
            }
        case .second:
            println("out")
        }
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