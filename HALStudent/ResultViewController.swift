//
//  Result.swift
//  Student
//
//  Created by sotuken on 2015/08/03.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController :UIViewController, CorePeripheralManagerDelegate {
    
    var questions :QuestionBox!
//    var studentData :StudentData!
    
    var correctNum :Int = 0
    
    //正解数ラベル
    @IBOutlet weak var ansLabel: UILabel!
    
    //スコアラベル
    @IBOutlet weak var scLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
//        judge()
  
        
        //実施問題数の取得
        var questionCount = QuestionBox.questionBoxInstance.selectQuestion.count

        //正解数の取得
        var correct = QuestionAnswerBox.questionAnswerBoxInstance.getCorrectCount()        
        
        //ラベルに正解数表示
        ansLabel.text = "正解数 \(correct) / \(questionCount) 問"
        
        if(correct == questionCount){
            scLabel.text = "得点 100 点"
        }
        
        else{
            //ラベルに得点表示
            var score = 100/questionCount*correct
            scLabel.text = "得点 \(score) / 100 点"
        }
        
        // ナビゲーションバーをつける
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
//    /**
//    正誤判定を行う
//    正回数をカウントする
//    */
//    func judge(){
//        for(var i=0;i < QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer.count; i++){
//            if(QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer[i]?.judge.toInt() > 0){
//                correctNum++
//            }
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goToAnswerCheck(sender: AnyObject) {
        self.performSegueWithIdentifier("resultDetail", sender: self )
    }
    
    override func viewWillAppear(animated: Bool) {
        CorePeripheralManager.corePeripheralInstance.delegate = self
    }

    
    
    
    // --------デリゲート--------
    
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}