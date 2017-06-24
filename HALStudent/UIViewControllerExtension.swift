//
//  UIViewControllerExtension.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/26.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

var menuElemSelector: Selector = Selector("menuElem")

extension UIViewController {
    
    var menu: MenuElem {
        get {
            return objc_getAssociatedObject(self, &menuElemSelector) as! MenuElem
        }
        set {
            objc_setAssociatedObject(self, &menuElemSelector, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC)) ;
        }
    }
}