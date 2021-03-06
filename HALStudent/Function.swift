//
//  HTMLParser.swift
//  HALTeacher
//
//  Created by Toshiki Higaki on 2015/08/29.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


/**
htmlの文字を消す

:param: part 対象の文字列
*/
func htmlParse(part: String)->String{
    
    var parsedText = ""
    var startFlag = false
    var endFlag = false
    //<p>タグの有無を確認
    if(part.rangeOfString("<p>")?.isEmpty == false) {
        startFlag = true
    }
    if(part.rangeOfString("</p>")?.isEmpty == false){
        endFlag = true
    }
    
    parsedText = part
    
    while(startFlag == true || endFlag == true ) {
        
        parsedText = parsedText.stringByReplacingOccurrencesOfString("<p>", withString: "", options: nil, range: nil)
        parsedText = parsedText.stringByReplacingOccurrencesOfString("</p>", withString: "\n", options: nil, range: nil)
        parsedText = parsedText.stringByReplacingOccurrencesOfString("<br>", withString: "", options: nil, range: nil)
        parsedText = parsedText.stringByReplacingOccurrencesOfString("&nbsp;", withString: "", options: nil, range: nil)
        
        //他にもタグがあるか確認
        if(parsedText.rangeOfString("<p>")?.isEmpty == false) {
            startFlag = true
        }else{
            startFlag = false
        }
        if(parsedText.rangeOfString("</p>")?.isEmpty == false){
            endFlag = true
        }else{
            endFlag = false
        }
    }
    return parsedText
}

/**
マークから配列番号を返す

:param: mark マーク
*/
func getMarkNumber(mark: String) -> Int{
    switch(mark) {
    case "A":
        return 0
    case "B":
        return 1
    case "C":
        return 2
    case "D":
        return 3
    case "E":
        return 4
    case "F":
        return 5
    case "G":
        return 6
    case "H":
        return 7
    default:
        return 0
    }
}

/**
マークから配列番号を返す

:param: mark マーク
*/
func getMark(number: Int) -> String {
    switch(number) {
    case 0:
        return "A"
    case 1:
        return "B"
    case 2:
        return "C"
    case 3:
        return "D"
    case 4:
        return "E"
    case 5:
        return "F"
    case 6:
        return "G"
    case 7:
        return "H"
    default:
        return "nil"
    }
}


/**
現在の一番上のviewを取得
*/
func getTopMostController() -> UIViewController {
    var topController: UIViewController = (UIApplication.sharedApplication()).keyWindow!.rootViewController!
    
    while ((topController.presentedViewController) != nil) {
        topController = topController.presentedViewController!
    }
    
    return topController
}


/**
現在の一番上のviewControllerを取得
*/
func getTopViewController() -> UIViewController {
    var topController: UIViewController = (UIApplication.sharedApplication()).keyWindow!.rootViewController!
    var topViewController: UIViewController = (UIApplication.sharedApplication()).keyWindow!.rootViewController!
    var i=0
    
    while ((topController.presentedViewController) != nil) {
        topController = topController.presentedViewController!
        if topController as? UIAlertController == nil {
            topViewController = topController
        }
    }
    
    return topViewController
}


/**
AlertViewの作成
*/
func lockAlertView() {
    var viewController = getTopMostController()

    if (viewController as? UIAlertController == nil) {
        //indicator宣言
        var indicator :UIActivityIndicatorView!
        
        //ダウンロード中のalertView
        var downloadingAlertView :UIAlertController!
        
        //indicatorの初期化
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        var alertView = UIAlertController(title: "ロック中です", message:"前を向いてください。", preferredStyle: .Alert)
        
        ////    var okAction = UIAlertAction(title: "ダウンロード", style: UIAlertActionStyle.Default) {
        ////        UIAlertAction in
        ////
        ////        //前のalertviewの削除（意味ないかも）
        ////        alertView.dismissViewControllerAnimated(true, completion: nil)
        ////
        ////        //AlertController作成
        ////        downloadingAlertView = UIAlertController(title: "ダウンロード中", message: "\n\n", preferredStyle: .Alert)
        ////        //indicatorの位置決め
        ////        indicator.center = CGPointMake(alertView.view.frame.size.width/2 ,downloadingAlertView.view.frame.size.height/15)
        ////
        ////        //indicatorを回す
        ////        indicator.startAnimating()
        ////
        ////        //AlertControllerにindicatorを追加させる
        ////        downloadingAlertView.view.addSubview(indicator)
        ////
        ////        //Viewを見せる
        ////        viewController.presentViewController(downloadingAlertView, animated: true, completion: nil)
        ////    }
        ////
        ////    var cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Default) {
        ////        UIAlertAction in
        ////    }
        //
        //    // Add the actions
        //    alertView.addAction(okAction)
        //    alertView.addAction(cancelAction)
        
        // Present the controller
        viewController.presentViewController(alertView, animated: true, completion: nil)
    }
}


/**
AlertViewの削除
*/
func dismissLockAlertView() {
    var viewController = getTopMostController()
    if (viewController as? UIAlertController != nil) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}


/**
スクリーンショットとる
*/
func screenShot(){
    var viewController = getTopMostController()

    if (viewController as? UIAlertController != nil) {
        viewController = getTopViewController()
    }
    let view = viewController.view
    
    // スクリーンショットの取得開始
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 1.0)
    
    // 描画
    view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
    
    // 描画が行われたスクリーンショットの取得
    let screenShot = UIGraphicsGetImageFromCurrentImageContext()
    
    // スクリーンショットの取得終了
    UIGraphicsEndImageContext()
    
    sendImage(screenShot)
    
}


/**
画像を送る
*/
func sendImage(screenShot: UIImage){
    
    let userID = StudentInfo.studentInfoInstance.userID!
    
    // ライブラリーのインススタンス作成
    let net = Net(baseUrlString: MoodleInfo.moodleInfoInstance.moodleURL!+"/screenShot/")
    
    // 送信先のphpファイル名
    let url = "imageUpload_rename.php"
    let params = ["icon": NetData(pngImage: screenShot, filename: String(userID)+".jpg")]
    net.POST(url, params: params, successHandler: {
        responseData in
        let result = responseData.data
        CorePeripheralManager.corePeripheralInstance.notification(CorePeripheralManager.corePeripheralInstance.monitoringUUID, sendData: nil)
        }, failureHandler: {
        error in
        println("Error")
    })
}
