//
//  HomeViewController.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/19.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBAction func unwindToTitle(segue: UIStoryboardSegue) {}
    
    //notificationを作成
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //アプリを落とした時
        notificationCenter.addObserver(self, selector: "endApp", name: UIApplicationWillTerminateNotification, object: nil)
        //ホームボタンを押した時や他のアプリを開いた時
        notificationCenter.addObserver(self, selector: "backApp", name: UIApplicationDidEnterBackgroundNotification, object: nil)

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    タッチした時
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        performSegueWithIdentifier("goNavigationSegue", sender: nil)
    }
    
    func endApp(){
        CorePeripheralManager.corePeripheralInstance.notification(CorePeripheralManager.corePeripheralInstance.homeUUID, sendData: "endApp")
        println("アプリ終了！")
    }
    func backApp(){
        CorePeripheralManager.corePeripheralInstance.notification(CorePeripheralManager.corePeripheralInstance.homeUUID, sendData: "pushHome")
        println("ホームボタン")
    }

}