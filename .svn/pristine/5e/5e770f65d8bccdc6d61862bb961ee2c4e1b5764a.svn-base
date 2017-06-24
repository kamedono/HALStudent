//
//  QCustomCell.swift
//  SimpleViewPager
//
//  Created by マイコン部 on 2015/07/16.
//  Copyright (c) 2015年 mitolab. All rights reserved.
//


import UIKit

class QCustomCell :UITableViewCell{
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var studentAnswerLabel: UILabel!
    @IBOutlet weak var QuestionAnswerTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setQText(questionNumber:String, questionText:String, studentAnswer:String, AnswerText:String){
        self.questionNumberLabel.text = questionNumber
        self.questionTextLabel.text = questionText
        self.studentAnswerLabel.text = studentAnswer
        self.QuestionAnswerTextLabel.text = AnswerText
    }
    
    // プロパティに追加
    @IBInspectable var questionNum: Int = 0 {
        didSet {
            self.questionNumberLabel.text = questionNum.description
        }
    }
    
    // プロパティに追加
    @IBInspectable var questionText: String = "" {
        didSet {
            self.questionTextLabel.text = questionText
        }
    }
    
    // プロパティに追加
    @IBInspectable var studentAnswerMark: String = "" {
        didSet {
            self.studentAnswerLabel.text = studentAnswerMark
        }
    }
    
    // プロパティに追加
    @IBInspectable var QuestionAnswerMark: String = "" {
        didSet {
            self.QuestionAnswerTextLabel.text = QuestionAnswerMark
        }
    }
}