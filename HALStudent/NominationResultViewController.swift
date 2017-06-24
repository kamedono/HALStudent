//
//  File.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/21.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class NominationResultViewController: UIViewController, CorePeripheralManagerDelegate {
    
    @IBOutlet weak var answerLabel: UILabel!
    
    var questions :QuestionBox!
    
    var correctNum :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        
        //実施問題数の取得
        var questionCount = QuestionBox.questionBoxInstance.selectQuestion.count
        
        //正解数の取得
        var correct = QuestionAnswerBox.questionAnswerBoxInstance.getCorrectCount()
        
        //ラベルに正解数表示
        self.answerLabel.text = "正解数 \(correct) / \(questionCount) 問"
        
        // ナビゲーションバーをつける
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)
        CorePeripheralManager.corePeripheralInstance.delegate = self

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}