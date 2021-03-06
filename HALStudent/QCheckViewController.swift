//
//  QCheckViewController.swift
//  SimpleViewPager
//
//  Created by マイコン部 on 2015/07/16.
//  Copyright (c) 2015年 mitolab. All rights reserved.
//

import UIKit

/**
* 指定した問題番号のページに戻すためのデリゲート
* デリゲート持ち主にユーザの押したページ番号を通知する
**/
protocol QCheckViewControllerDelegate{
    func popToQuestion(newPage : Int)
}

class QCheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FinishFunctionDelegate, CorePeripheralManagerDelegate {
    var delegate : QCheckViewControllerDelegate?
    var someViewController = SomeViewController()
    
    @IBOutlet weak var quessionTable: UITableView!
    
    //問題数
    var questionNum :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.quessionTable.dataSource = self
        self.quessionTable.delegate = self
        println("qu num : ", questionNum.description)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionBox.questionBoxInstance.selectQuestion.count
    }
    
    //indexPath :テーブルビューのindexが格納されている
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: QCustomCell
        let index = indexPath.row
        cell = tableView.dequeueReusableCellWithIdentifier("QuessionCell", forIndexPath: indexPath) as! QCustomCell
        var questionText = htmlParse(QuestionBox.questionBoxInstance.selectQuestion[index].question_text)
        
        // 問題番号取得
        let questionNumber: Int = QuestionBox.questionBoxInstance.selectQuestion[index].questionNumber
        
        // answerデータ取得
        let questionAnswer: QuestionAnswer = QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer[questionNumber]!
        
        var answerText: String = htmlParse(questionAnswer.questionText)
        
        cell.setQText("Q"+String(index + 1), questionText: questionText, studentAnswer: questionAnswer.mark, AnswerText: answerText)
        return cell
    }
    
    // セルを選択した場合に呼び出される
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //一つ前のビューに戻る
        self.navigationController?.popViewControllerAnimated(true)
        // 指定した問題番号のページに戻す（SimpleViewの中にあるviewの番号）
        self.delegate?.popToQuestion(indexPath.row)
    }
    
    @IBAction func goToAnswerCheck(sender: AnyObject) {
        self.performSegueWithIdentifier("resultView", sender: self )
    }
    
    // ページ遷移をする際に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "resultView") {
            let resultView: ResultViewController = segue.destinationViewController as! ResultViewController
            //            resultView.questions = questions
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        CorePeripheralManager.corePeripheralInstance.finishFunction.delegate = self
        CorePeripheralManager.corePeripheralInstance.delegate = self
    }
    
    
    
    // --------デリゲート--------
    
    
    /**
    結果画面に行って欲しいときに通知されるデリゲート
    */
    func goNextViewSegue() {
        self.performSegueWithIdentifier("goResultViewSegue", sender: nil)
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}