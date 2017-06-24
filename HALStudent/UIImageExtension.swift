//
//  UIImageExtention.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/23.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

extension UIImage {
    // プロパティに追加
    @IBInspectable var answerSentenceText: String = "" {
        didSet {
            self.answerSentenceLabel.text = answerSentenceText
        }
    }
}
