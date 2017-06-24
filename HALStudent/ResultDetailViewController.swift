//
//  QResult.swift
//  SimpleViewPager
//
//  Created by マイコン部 on 2015/07/16.
//  Copyright (c) 2015年 mitolab. All rights reserved.
//

import UIKit
class ResultDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CorePeripheralManagerDelegate {
    
//    var studentData :StudentData!
    var questions = QuestionBox.questionBoxInstance.selectQuestion
    var someViewController = SomeViewController()
    
    @IBOutlet weak var quessionTable2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("問題数:\(self.questions.count)")
        self.quessionTable2.dataSource = self
        self.quessionTable2.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        CorePeripheralManager.corePeripheralInstance.delegate = self

    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    /*
    *indexPath :テーブルビューのindexが格納されている
    *
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ResultCell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! ResultCell
        var questionText = htmlParse(self.questions[indexPath.row].question_text)
        
//        if(studentData.studentAnswer[indexPath.row]?.questionText.isEmpty == nil){
//            cell.setQText("Q"+String(indexPath.row + 1), RQT: questionText, RAM: studentData.studentAnswerMark[indexPath.row], RAT: "未入力")
//        }else{
//            var answerText = someViewController.htmlParse(studentData.studentAnswer[indexPath.row]!.questionText)
//            cell.setQText("Q"+String(indexPath.row + 1), RQT: questionText, RAM: studentData.studentAnswerMark[indexPath.row], RAT: answerText)
//        }
        
        // answerデータ取得
        let questionAnswer = QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer[QuestionBox.questionBoxInstance.selectQuestion[indexPath.row].questionNumber]
        
        var answerText = htmlParse(QuestionBox.questionBoxInstance.selectQuestionRightAnswerList[indexPath.row])
        var answerMark = htmlParse(QuestionBox.questionBoxInstance.selectQuestionRightAnswerMarkList[indexPath.row])
        
        if(QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer[indexPath.row]?.questionText.isEmpty == nil){
            cell.setQText("Q"+String(indexPath.row + 1), RQT: questionText, RAM: questionAnswer!.mark, RAT: answerText, rightAnswerMark: answerMark)
        }else{
            cell.setQText("Q"+String(indexPath.row + 1), RQT: questionText, RAM: questionAnswer!.mark, RAT: answerText, rightAnswerMark: answerMark)
        }

        if questionAnswer?.mark == answerMark {
            cell.judgeImage.image = UIImage(named: "maruClear.png")
        }
        
        return cell
    }

    
    
    // --------デリゲート--------
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}



