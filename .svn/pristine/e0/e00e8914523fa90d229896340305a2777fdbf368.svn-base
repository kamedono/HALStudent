//
//  Extension.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/19.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

extension UIColor {
    class func hexStr (var hexStr : NSString, var alpha : CGFloat) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.whiteColor();
        }
    }
    class func navigationColor() -> UIColor {
        return UIColor.hexStr("#FF8C01", alpha: 1)
    }
}