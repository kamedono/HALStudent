//
//  ScreenShot.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/08/31.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import UIKit

class ScreenShot:NSURLSessionDelegate,NSURLSessionDataDelegate{
    /**
    スクリーンショットとる
    */
    func pushScreenShot(){
        // スクリーンショットの取得開始
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 1.0)
        // 描画
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        // 描画が行われたスクリーンショットの取得
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        println(screenShot)
        // スクリーンショットの取得終了
        UIGraphicsEndImageContext()
        self.screenShot = screenShot
        sendImage()
    }
    
    /**
    画像を送る
    */
    func sendImage(){
        self.counter--
        //ライブラリーのインススタンス作成
        net = Net(baseUrlString: "http://192.168.113.44:8888/")
        //送信先のphpファイル名
        let url = "imageUpload_rename.php"
        var params = ["icon": NetData(pngImage: screenShot!, filename: "i"+String(counter)+".jpg")]
        net.POST(url, params: params, successHandler: {
            responseData in
            let result = responseData.data
            
            let mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            dispatch_async(dispatch_get_main_queue(), {
                self.testLabel.text = "i"+String(self.counter)+"の画面です"
            })
            //            let result = responseData.json(error: nil)
            //            NSLog("result: \(result)")
            }, failureHandler: { error in
                NSLog("Error")
        })
        if(self.counter > 0){
            pushScreenShot()
        }else{
            println("おわりました")
        }
    }
    
    /*
    通信終了時に呼び出されるデリゲート.
    */
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        println("didCompleteWithError")
        
        // エラーが有る場合にはエラーのコードを取得.
        println(error?.code)
    }
}