//
//  StudentData.swift
//  Student
//
//  Created by sotuken on 2015/08/01.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

class QuestionAnswerBox {

    static let questionAnswerBoxInstance = QuestionAnswerBox()

    //問題の解答結果を格納
    var studentAnswer: Dictionary<Int, QuestionAnswer> = [:]
    
    //解答のマークを保存（A,B,C,D...）
//    var studentAnswerMark: [String] = []
    
    
    //初期設定
    init() {

    }
    
    // 初期化の代わり
    func setEmpty() {
        self.studentAnswer = [:]
//        self.studentAnswerMark = []
    }
    
    /**
    正解した個数を返す
    */
    func getCorrectCount() -> Int {
        var count: Int = 0
        
        for questionAnswer in studentAnswer.values.array {
            var judge = questionAnswer.judge
            if(questionAnswer.judge != "0" && questionAnswer.mark != "未解答") {
                count++
            }
        }
        return count
    }
}
