//
//  QResult.swift
//  SimpleViewPager
//
//  Created by マイコン部 on 2015/07/16.
//  Copyright (c) 2015年 mitolab. All rights reserved.
//

import UIKit
class ResultDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    var studentData :StudentData!
    var questions = QuestionBox.questionBoxInstance
    var someViewController = SomeViewController()
    
    @IBOutlet weak var quessionTable2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("問題数:\(questions.questions.count)")
        self.quessionTable2.dataSource = self
        self.quessionTable2.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.questions.count
    }
    
    /*
    *indexPath :テーブルビューのindexが格納されている
    *
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ResultCell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! ResultCell
        var questionText = htmlParse(questions.questions[indexPath.row].question_text)
        
//        if(studentData.studentAnswer[indexPath.row]?.questionText.isEmpty == nil){
//            cell.setQText("Q"+String(indexPath.row + 1), RQT: questionText, RAM: studentData.studentAnswerMark[indexPath.row], RAT: "未入力")
//        }else{
//            var answerText = someViewController.htmlParse(studentData.studentAnswer[indexPath.row]!.questionText)
//            cell.setQText("Q"+String(indexPath.row + 1), RQT: questionText, RAM: studentData.studentAnswerMark[indexPath.row], RAT: answerText)
//        }
        
        // answerデータ取得
        let questionAnswer: [QuestionAnswer] = QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer.values.array as [QuestionAnswer]
        
        if(QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer[indexPath.row]?.questionText.isEmpty == nil){
            cell.setQText("Q"+String(indexPath.row + 1), RQT: questionText, RAM: questionAnswer[indexPath.row].mark, RAT: "未入力")
        }else{
            var answerText = htmlParse(QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer[indexPath.row]!.questionText)
            cell.setQText("Q"+String(indexPath.row + 1), RQT: questionText, RAM: questionAnswer[indexPath.row].mark, RAT: answerText)
        }
        return cell
    }
    
}



