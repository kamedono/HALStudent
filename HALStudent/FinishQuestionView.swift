//
//  FinishQuestionView.swift
//  Student
//
//  Created by sotuken on 2015/08/04.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class FinishQuestionView : UIViewController, CorePeripheralManagerDelegate {
    var coreData = CoreData_module()
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}