//
//  MenuElm.swift
//  Student
//
//  Created by sotuken on 2015/07/28.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

class MenuElem: NSObject {
    let NameKey = "name"
    let ClassNameKey = "cn"
    let StoryBoardKey = "sb"
    
    var question :QuestionXML!
    
    var menu: Dictionary<String, String> = [:]
    var questionNum:Int
    
    //リストに書くもの
    init(name: String, className: String, sbName: String, question: QuestionXML, num: Int) {
        menu[NameKey] = name
        menu[ClassNameKey] = className
        menu[StoryBoardKey] = sbName
        self.question = question
        questionNum = num
    }
    
    func name() -> String {
        return menu[NameKey]!
    }
    func className() -> String {
        return menu[ClassNameKey]!
    }
    func storyBoardName() -> String {
        return menu[StoryBoardKey]!
    }
    func getNum() ->Int {
        return questionNum
    }
}