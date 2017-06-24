//
//  TopSegue.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/10/04.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class TopSegue: NSObject {
    
    // デリゲート宣言
    var delegate: QuizFinishDelegate!
    
    // 現在のViewControllerを取得
    var topViewController: UIViewController! {
        get {
            return getTopViewController()
        }
    }
    
    /**
    解答の終了時のアラート
    */
    func timerFinishAlert() {
        dispatch_async(dispatch_get_main_queue(), {
            // AlertController作成
            var downloadingAlertView = UIAlertController(title: "解答時間が終了しました！", message: "詳細ページに移行します", preferredStyle: .Alert)
            
            // わかったボタン
            var acceptAction = UIAlertAction(title: "わかった!", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.delegate?.goNextViewSegue()
            }
            // AlertControllerにindicatorを追加させる
            downloadingAlertView.addAction(acceptAction)
            let topview = self.topViewController
            // Viewを見せる
            topview.presentViewController(downloadingAlertView, animated: true, completion: nil)
        })
    }
    
    /**
    クイズの終了時のアラート
    */
    func finishAlert() {
        dispatch_async(dispatch_get_main_queue(), {
            // AlertController作成
            var downloadingAlertView = UIAlertController(title: "クイズが終了しました！", message: "トップに移行します", preferredStyle: .Alert)
            
            // わかったボタン
            var acceptAction = UIAlertAction(title: "わかった!", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.delegate?.goNextViewSegue()
            }
            // AlertControllerにindicatorを追加させる
            downloadingAlertView.addAction(acceptAction)
            let topview = self.topViewController
            // Viewを見せる
            topview.presentViewController(downloadingAlertView, animated: true, completion: nil)
        })
    }
    
    //    /**
    //    画面の遷移
    //    */
    //    func goResultViewController() {
    //        var targetViewController: AnyObject? = self.topViewController.storyboard?.instantiateViewControllerWithIdentifier("ResultView")
    //        self.topViewController.navigationController?.pushViewController(targetViewController as! UIViewController, animated: true)
    //
    //    }
    
}