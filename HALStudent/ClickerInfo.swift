//
//  ClickerInfo.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/26.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation

@objc(ClickerInfo)
class ClickerInfo : NSObject , NSCoding {
    
    static let clickerInfoInstance = ClickerInfo()
    
    // 問題文
    var questionText: String? = "マイクロソフトのOSといえばどれ？"
    
    // 解答群
    var answerList: [String]? = ["Windows", "Mac", "Linux", "その他"]
    
    // 解答群数
    var answerNumber: Int?
    
    // 自分が選択したデータ
    var selectMark: String?
    
    // 終了判定
    var status: String?
    
    let student = StudentInfo.studentInfoInstance.userID
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.questionText = aDecoder.decodeObjectForKey("clickerTitle") as? String
        self.answerList = aDecoder.decodeObjectForKey("answerList") as? [String]
        //        self.status = aDecoder.decodeObjectForKey("status") as? String
        //    self.answerNumber = aDecoder.decodeObjectForKey("answerNumber") as? Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.selectMark, forKey: "selectMark")
        aCoder.encodeObject(self.student, forKey: "studentUserID")
    }
    
    /**
    NSDataに変換する関数
    */
    func archiveNSData() -> NSData{
        var dataArray: [AnyObject] = []
        
        dataArray.append(self.selectMark!)
        dataArray.append(self.student!)
        return NSKeyedArchiver.archivedDataWithRootObject(dataArray)
    }
    
    // 初期化の代わり
    func setEmpty() {
        self.questionText = nil
        self.answerList = []
        self.answerNumber = nil
    }
    
    func setData(clickerInfo: ClickerInfo) {
        self.questionText = clickerInfo.questionText
        self.answerList = clickerInfo.answerList
        self.answerNumber = clickerInfo.answerNumber
    }
}
