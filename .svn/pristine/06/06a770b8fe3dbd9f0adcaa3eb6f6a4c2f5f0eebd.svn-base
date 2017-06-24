//
//  QResultCell.swift
//  SimpleViewPager
//
//  Created by マイコン部 on 2015/07/16.
//  Copyright (c) 2015年 mitolab. All rights reserved.
//

import UIKit

class ResultCell :UITableViewCell{
    
    @IBOutlet weak var ResultQuestionNumberLabel: UILabel!
    @IBOutlet weak var ResultQuestionText: UILabel!
    @IBOutlet weak var ResultAnswerMark: UILabel!
    @IBOutlet weak var resultRightAnswerMark: UILabel!
    @IBOutlet weak var resultRightAnswerText: UILabel!
    @IBOutlet weak var judgeImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setQText(RQNL:String,RQT:String,RAM:String,RAT:String, rightAnswerMark: String){
        self.ResultQuestionNumberLabel.text = RQNL
        self.ResultQuestionText.text = RQT
        self.ResultAnswerMark.text = RAM
        self.resultRightAnswerText.text = RAT
        self.resultRightAnswerMark.text = rightAnswerMark

    }
    
}
