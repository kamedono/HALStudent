//
//  AnswerButton.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/08/04.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//


import UIKit

protocol AnswerViewDelegate{
    /**
    ボタンを押した時のデリゲート
    
    :param: mark AとかBとか
    :param: num 問題の番号
    :param: answerData 解答のデータの構造体
    */
    func pushAnswerButton(mark: String, answerNumber: Int, answerData: String)
}

@IBDesignable
class AnswerView: UIView {
    @IBOutlet weak var touchView: UIView!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerSentenceLabel: UILabel!
    
    var delegate: AnswerViewDelegate!
    
    var number: Int!
    
    /**
    コードで初期化した場合
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    /**
    xib,Storyboardで初期化した場合
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    
    // プロパティに追加
    @IBInspectable var answerText: String = "" {
        didSet {
            self.answerLabel.text = answerText
        }
    }
    
    // プロパティに追加
    @IBInspectable var answerSentenceText: String = "" {
        didSet {
            self.answerSentenceLabel.text = answerSentenceText
        }
    }
    
    /**
    xibからカスタムViewを読み込んで準備する
    */
    private func comminInit() {
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Answer", bundle: bundle)
        
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(0),
            metrics:nil,
            views: bindings))
    }
    
    
    /**
    えんぴつ型の解答ボタンのImageをセット
    */
    func setImage(imageName: String) {
        if let image: UIImage = UIImage(named: imageName){
            self.answerImageView.image = image
        }
        else {
            println("no image")
        }
    }
    
    
    /**
    Fontサイズを設定
    */
    func setFontSize(questionNumber: Int) {
        if questionNumber <= 4 {
            self.answerLabel.font = UIFont.systemFontOfSize(35)
            self.answerSentenceLabel.font = UIFont.systemFontOfSize(60)
        }
        
        else if questionNumber <= 6 {
            self.answerLabel.font = UIFont.systemFontOfSize(30)
            self.answerSentenceLabel.font = UIFont.systemFontOfSize(40)
        }
        
        else {
            self.answerLabel.font = UIFont.systemFontOfSize(20)
            self.answerSentenceLabel.font = UIFont.systemFontOfSize(20)
        }
    }

    
    /**
    Viewをタッチした時のデリゲート
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        super.touchesEnded(touches, withEvent: event)
        
        for touch: AnyObject in touches {
            self.delegate.pushAnswerButton("a", answerNumber: self.number, answerData: "c")
        }
    }
    
}