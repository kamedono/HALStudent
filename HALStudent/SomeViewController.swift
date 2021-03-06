//
//  SomeViewController.swift
//  SimpleViewPager
//
//  Created by YuheiMiyazato on 4/8/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

//画面は縦向きのもの
//横向きになったらちゃんとBとDのボタンは横にずれるよ

//参考
//http://qiita.com/mito_log/items/4e580114c91d80dca9e1

import Foundation
import UIKit

var menuElemSelector: Selector = Selector("menuElem")

extension UIViewController {
    
    var menu: MenuElem {
        get {
            return objc_getAssociatedObject(self, &menuElemSelector) as! MenuElem
        }
        set {
            objc_setAssociatedObject(self, &menuElemSelector, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) ;
        }
    }
}

class SomeViewController: UIViewController, AnswerViewDelegate {
    // 解答ボタンの画像の色リスト
    var imageList: [String] = ["Red.png", "Orange.png", "Yellow.png", "LightGreen.png", "Green.png", "LightBlue.png", "Blue.png", "Purple.png"]
    var deepImageList: [String] = ["DeepRed.png", "DeepOrange.png", "DeepYellow.png", "DeepLightGreen.png", "DeepGreen.png", "DeepLightBlue.png", "DeepBlue.png", "DeepPurple.png"]

    
    //ChoseAnswerLabel
    @IBOutlet weak var CAlabel: UILabel!
    
    //問題番号
    @IBOutlet weak var Qlabel: UILabel!
    
    //問題内容
    @IBOutlet weak var questionText: UILabel!
    
    //問題画像
    @IBOutlet weak var img: UIImageView!
    var imgSetFlag :Bool = false
    var questionNumber:Int = 0
    
    
    //問題情報
    var question: QuestionXML!
    
    //    var delegate : SomeViewControllerDelegate!
//    var coreData :CoreData_module = CoreData_module()
    
    var firstFlag = false
    
    
    //問題の回数呼ばれる
    override func viewDidLoad() {
        
        // 画面サイズを取得 Windowの表示領域すべてのサイズ(point).
        let boundsFrameSize: CGSize = UIScreen.mainScreen().bounds.size
        
        // 問題数が入る
        let questionCount: Int = question.answers.count
        
        // 高度な計算
        let yPoint = Int(boundsFrameSize.height / 5 * 3 - 200)
        
        // ボタンを生成！
        for (var i=1; i <= questionCount; i++){
            // viewの一つあたりのサイズ
            let height = CGFloat((Int(boundsFrameSize.height) - yPoint - 200) / ((questionCount + 1) / 2))
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
            //            let bundle = NSBundle(forClass: self.dynamicType)
            //            let nib = UINib(nibName: "Answer", bundle: bundle)
            //
            //            let customView = nib.instantiateWithOwner(self, options: nil).first as! AnswerView
            
            //htmlタグの削除
            let questionText = htmlParse(question.answers[i-1].questionText)
            
            // 解答文とかセット！
            customView.answerLabel.text = questionText
            customView.answerSentenceLabel.text = question.answers[i-1].mark
            
//            // 縁の設定
//            customView.layer.borderColor = UIColor.clearColor().CGColor
//            customView.layer.borderWidth = 0
            
            // 解答ボタンの画像の設定
            customView.setImage(imageList[i-1])
            
            // 初期化したインスタンスのdelegateを自身にセット
            customView.delegate = self
            
            // 問題などをセット。本当はもっと長い
            customView.number = i-1
            
            // フォントサイズ設定
            customView.setFontSize(questionCount)
            
            //            self.list.append(customView)
            
            view.addSubview(customView)
        }
        
        
        //UIScrollViewを作成します
        let scrollView = UIScrollView()
        
        //表示位置 + 1ページ分のサイズ
        scrollView.frame = CGRectMake(0, -40, 1000, CGFloat(yPoint))
        scrollView.layer.position = CGPoint(x: 500, y: 100)
        
        
        let questionNumberLabel = UILabel()
        var questionTextLabel = UILabel()
        var questionTextLabelWidth = NSLayoutConstraint()
        
        //問題番号
        questionNumberLabel.frame = CGRectMake(10, 5, 50, 30)
        questionNumberLabel.text = "Q"+String(menu.getNum()+1)
        questionNumberLabel.font = UIFont.systemFontOfSize(30)
        questionNumberLabel.sizeToFit()
        
        //問題文
        if (QuestionBox.questionBoxInstance.selectQuestion[menu.getNum()].question_text.rangeOfString("<img")?.isEmpty == false) {
            questionTextLabel.text = imgSetter(QuestionBox.questionBoxInstance.selectQuestion[menu.getNum()].question_text)
        }
        else {
            questionTextLabel.text = htmlParse(QuestionBox.questionBoxInstance.selectQuestion[menu.getNum()].question_text)
        }
        questionTextLabel.font = UIFont.systemFontOfSize(30)
        questionTextLabel.frame = CGRectMake(40, 50, 900, 5000)
        questionTextLabel.numberOfLines = 0
        questionTextLabel.sizeToFit()
        
        var questionImageView:UIImageView = UIImageView()
        if(!QuestionBox.questionBoxInstance.selectQuestion[menu.getNum()].question_file.isEmpty){
            let DecodeData = NSData(base64EncodedString: question.question_file, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            questionImageView = UIImageView(image: UIImage(data: DecodeData!)!)
        }
        questionImageView.frame = CGRectMake(0, 50+questionTextLabel.bounds.height, questionImageView.bounds.width, questionImageView.bounds.height)
        
        
        //全体のサイズ
        scrollView.contentSize = CGSizeMake(1000, questionTextLabel.bounds.height+50+questionImageView.bounds.height)
        self.view.addSubview(scrollView)
        scrollView.addSubview(questionNumberLabel)
        scrollView.addSubview(questionTextLabel)
        scrollView.addSubview(questionImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    //正誤判定を行う
    //    func judge(){
    //        self.question.answer_judge[]
    //    }
    
    
    
    
    // ----Delegate宣言----
    
    
    /**
    ボタンを押した時のデリゲート
    ボタンの色とかを変える
    
    :param: mark AとかBとか
    :param: num 問題の番号
    :param: answerData 解答のデータの構造体
    */
    func pushAnswerButton(mark: String, answerNumber: Int, answerData: String){
        for view in self.view.subviews as! [UIView] {
            if let answerView = view as? AnswerView {
                // タッチしたボタンかどうかの判定
                if answerView.number != answerNumber {
//                    println(view.subviews)
//                    println((view.subviews[0] as! UIView).subviews)
//                    (view.subviews[0] as! UIView).backgroundColor = UIColor.whiteColor()
                    ((view.subviews[0] as! UIView).subviews[1]as! UIView).backgroundColor = UIColor.whiteColor()
                }
                else{
//                    (view.subviews[0] as! UIView).backgroundColor = UIColor.greenColor()
//                    ((view.subviews[0] as! UIView).subviews[0]as! UIView).backgroundColor = UIColor.redColor()
                    ((view.subviews[0] as! UIView).subviews[1]as! UIView).backgroundColor = UIColor.clearColor()
                    
                    // 問題番号を取得
                    let questionNumber = QuestionBox.questionBoxInstance.selectQuestion[menu.getNum()].questionNumber
                    
                    // Answerを保存
                    QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer.updateValue(self.question.answers[answerNumber], forKey: questionNumber)
                    println("menu num : ",menu.getNum())
                    println("num : ",answerNumber)
                    println("questionNumber : ",questionNumber)
                    
                    // 教員へ解答送信
                    CorePeripheralManager.corePeripheralInstance.notification(CorePeripheralManager.corePeripheralInstance.answerUUID, sendData: question.answers[answerNumber])
                }
            }
        }
    }
}