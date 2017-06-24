//
//  CorePeripheralManager.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/08/27.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import CoreBluetooth

@objc protocol CorePeripheralManagerDelegate{
    
    /**
    Bluetoothがonになった時通知
    */
    optional func statePoweredOn()
    
    /**
    Bluetoothがoffになった時通知
    */
    optional func statePoweredOff()
    
    /**
    Quizのready書き込みが来た時通知
    */
    optional func quizReady(URL: String)
    
    /**
    Quizのstart書き込みが来た時通知
    */
    optional func quizStart(type: String)
    
    /**
    Quizの教員が問題を選んだ書き込みが来た時通知
    */
    optional func quizSelectQuestion()
    
    /**
    教員端末と接続した時通知
    */
    optional func connectTeacher()
    
    /**
    教員端末と接続した時通知
    */
    optional func disconnectTeacher()
    
    /**
    スクリーンショットのリクエストがあった時
    */
    optional func ssUploadRequest()
    
    /**
    クリッカーのstart書き込みが来た時通知
    */
    optional func clickerStart(type: String)
    
    /**
    クリッカーの終了通知
    */
    optional func clickerFinish(status: String?)
    
    /**
    教員の選んだコンテンツ、ステータスの通知
    */
    optional func selectContent(type: String)
    
    /**
    webのロック通知
    */
    optional func webLock(status: String)
    
    /**
    webのURL受信通知
    */
    optional func webGetedURL(url: String)
    
    /**
    webのURL受信通知
    */
    optional func goTopTableViewSegue()
    
    /**
    結果画面に行って欲しいときに通知されるデリゲート
    */
    optional func goNextViewSegue()
    
}

class CorePeripheralManager: NSObject, CBPeripheralManagerDelegate {
    
    internal struct SendData {
        var data: NSData
        var characteristic: CBMutableCharacteristic
    }
    
    static var corePeripheralInstance = CorePeripheralManager()
    
    var peripheralManager: CBPeripheralManager!
    
    var service: CBMutableService!
    
    var centralList: Dictionary <NSUUID, CBCentral> = [:]
    
    var serviceList: [CBService] = []
    
    var characteristics: [CBMutableCharacteristic] = []
    
    var connectStudentList: Dictionary <NSUUID, StudentInfo> = [:]
    
    var characteristicList: Dictionary <CBUUID, CBMutableCharacteristic> = [:]
    
    var sendDataList: [SendData] = []
    
    var delegate: CorePeripheralManagerDelegate!
    
    var finishFunction: FinishFunction = FinishFunction()
    
    var serviceUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B6")
    
    var loginUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B7")
    
    var answerUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B8")
    
    var quizFinishUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207B9")
    
    var quizStartUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BA")
    
    var quizReadyUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BB")
    
    var quizSelectQuestionUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BC")
    
    var monitoringUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BD")
    
    var lockUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BE")
    
    var homeUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207BF")
    
    var soundEffectUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C0")
    
    var clickerUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C1")
    
    var freeClickerUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C4")
    
    var clickerStatusUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C5")
    
    var statusUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C2")
    
    var webUUID = CBUUID(string: "1D57D189-86B6-04EA-0B52-D24DC69207C3")
    
    var serviceFlag: Bool?
    
    override init() {
        super.init()
        
        // CBPMの初期化
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        self.peripheralManager.delegate = self
        
        // サービス生成
        self.service = CBMutableService(type: self.serviceUUID, primary: true)
        
        // キャラクタリスティック生成
        self.addCharacteristic(self.loginUUID)
        self.addCharacteristic(self.answerUUID)
        self.addCharacteristic(self.quizFinishUUID)
        self.addCharacteristic(self.quizStartUUID)
        self.addCharacteristic(self.quizReadyUUID)
        self.addCharacteristic(self.quizSelectQuestionUUID)
        self.addCharacteristic(self.monitoringUUID)
        self.addCharacteristic(self.lockUUID)
        self.addCharacteristic(self.homeUUID)
        self.addCharacteristic(self.soundEffectUUID)
        self.addCharacteristic(self.clickerUUID)
        self.addCharacteristic(self.statusUUID)
        self.addCharacteristic(self.webUUID)
        self.addCharacteristic(self.freeClickerUUID)
        self.addCharacteristic(self.clickerStatusUUID)

        
        // サービスにキャラクタリスティックを追加
        self.service.characteristics = self.characteristicList.values.array
        
    }
    
    /**
    Advertiseを開始
    */
    func advertisementStart() {
        let advertisementDate: Dictionary = [CBAdvertisementDataLocalNameKey: StudentInfo.studentInfoInstance.name!]
        self.peripheralManager.startAdvertising(advertisementDate)
    }
    
    /**
    Advertiseを停止
    */
    func advertisementStop() {
        self.peripheralManager.stopAdvertising()
    }
    
    /**
    検索ワードの削除
    */
    func removeForKey(targetArray: [String], key: String) -> [String]{
        var count = 0
        var array = targetArray
        for element in array {
            if (element == key){
                array.removeAtIndex(count)
                return array
            }
            count++
        }
        return array
    }
    
    
    /**
    キャラクタリスティックを生成し、サービスに追加
    
    :param: uuid キャラクタリスティックのUUIDを渡す
    */
    func addCharacteristic(uuid: CBUUID){
        var characteristic: CBMutableCharacteristic!
        switch(uuid) {
        case loginUUID:
            let studentInfo: NSData = StudentInfo.studentInfoInstance.archiveNSData()
            characteristic = CBMutableCharacteristic(
                type: uuid,
                properties: CBCharacteristicProperties.Read,
                value: studentInfo,
                permissions: CBAttributePermissions.Readable)
            
        default:
            characteristic = CBMutableCharacteristic(
                type: uuid,
                properties: CBCharacteristicProperties.Read | CBCharacteristicProperties.Write | CBCharacteristicProperties.Notify | CBCharacteristicProperties.WriteWithoutResponse,
                value: nil,
                permissions: CBAttributePermissions.Readable | CBAttributePermissions.Writeable)
        }
        
        
        // キャラクタリスティックを保存
        self.characteristicList.updateValue(characteristic, forKey: uuid)
        //        self.characteristics.append(characteristic)
        
    }
    
    
    /**
    教員に対しての通知全般
    
    :param: UUID 送信するcharacteristicのUUID
    :param: sendURL 学生に送るデータ
    */
    func notification(UUID: CBUUID, sendData: AnyObject?){
        // sendDataでは送るデータを、dataではキャラクタリスティックにセットするデータを
        // dataが大きすぎると送れない模様
        
        var data: NSData
        var setData: NSData
        
        switch(UUID){
            // 解答を送信する
        case answerUUID:
            let str = "Notify"
            data = str.dataUsingEncoding(NSUTF8StringEncoding)!
            
            let questionAnswer: QuestionAnswer = sendData as! QuestionAnswer
            // NSDataにアーカイブ
            setData = NSKeyedArchiver.archivedDataWithRootObject(questionAnswer)
            
            //            setData = questionAnswer.archiveNSData()
            
            
            // テスト終了を送信する
        case quizFinishUUID:
            let str = "Finish"
            data = str.dataUsingEncoding(NSUTF8StringEncoding)!
            setData = data
            
        case monitoringUUID:
            let userID = StudentInfo.studentInfoInstance.userID
            data = userID!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            setData = data
            
        case clickerUUID:
            let str = "Clicker"
            data = str.dataUsingEncoding(NSUTF8StringEncoding)!
            //            data = NSKeyedArchiver.archivedDataWithRootObject(ClickerInfo.clickerInfoInstance)
            //            setData = ClickerInfo.clickerInfoInstance.archiveNSData()
            setData = NSKeyedArchiver.archivedDataWithRootObject(ClickerInfo.clickerInfoInstance)
            println(data)
            
        case homeUUID:
            data = (sendData as! String).dataUsingEncoding(NSUTF8StringEncoding)!
            setData = data
            
        default:
            data = NSKeyedArchiver.archivedDataWithRootObject("nil")
            setData = data
        }
        
        // キャラクタリスティックを取得
        var quizCharacteristic = self.characteristicList[UUID]
        
        self.characteristicList[UUID]!.value = setData
        
        // 送るけど送れなかった場合
        if !self.peripheralManager.updateValue(data, forCharacteristic: quizCharacteristic, onSubscribedCentrals: nil) {
            println("no")
            sendDataList.append(SendData(data: data, characteristic: quizCharacteristic!))
        }
    }
    
    
    /**
    書き込み通信が来た場合の関数
    
    :param: request 書き込みリクエストのデータ
    */
    func writeRequest(request: CBATTRequest!){
        switch(request.characteristic.UUID){
            
        case quizReadyUUID:
            
            let url: String = NSString(data: request.value, encoding:NSUTF8StringEncoding) as! String
            self.delegate?.quizReady?(url)
            println(url)
            
        case quizStartUUID:
            let type: String = NSString(data: request.value, encoding:NSUTF8StringEncoding) as! String
            switch(type) {
                // クイズ全員
            case "all":
                self.delegate?.quizStart?("all")
                
                // クイズ指名
            case "nomination":
                self.delegate?.quizStart?("nomination")
                
            default:
                self.delegate?.quizStart?("all")
                
            }
            println("start")
            
        case quizSelectQuestionUUID:
            
            // 空の配列を作成
            var selectQuestionListInt32: [Int32] = [Int32](count: request.value.length / sizeof(Int32), repeatedValue: 0)
            
            println("questions", request.value.length.description)
            
            // 配列一つ一つに対して値を入れる！
            request.value.getBytes(&selectQuestionListInt32, length: request.value.length * sizeof(Int32))
            
            // Int32に変換
            var selectQuestionListInt: [Int] = []
            for var i=0; i < selectQuestionListInt32.count; i++ {
                selectQuestionListInt.append(Int(selectQuestionListInt32[i]))
            }
            
            // 配列最後のシード値を取得・削除
            var seed = selectQuestionListInt.last!
            selectQuestionListInt.removeLast()
            
            // 選択されたデータをセット
            var selectQuestion: [QuestionXML] = []
            
            // 正解一覧
            var rightAnswerList: [String] = []
            var rightAnswerMarkList: [String] = []
            
            println("questions", selectQuestionListInt.description)
            
            for obj in selectQuestionListInt {
                let qs = QuestionBox.questionBoxInstance.questions
                var question = qs[obj]
                
                // 回答群をランダムに！
                if seed != 0 {
                    srand(UInt32(seed))
                    let r = rand()
                    for var i = 0; i < question.answers.count; i++  {
                        let j = Int(r) % (question.answers.count - i)
                        let tmp = question.answers[i]
                        question.answers[i] = question.answers[j]
                        question.answers[j] = tmp
                        println("ランダム :", j)
                    }
                    
                    // マーク文字列
                    let markList: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
                    
                    // Mark設定
                    for var i = 0; i < question.answers.count; i++  {
                        question.answers[i].mark = markList[i]
                        if question.answers[i].judge == "100" {
                            // 正解の保存（詳細で使う
                            rightAnswerList.append(question.answers[i].questionText)
                            rightAnswerMarkList.append(markList[i])
                        }
                    }
                    
                }
                
                // Questionを追加
                selectQuestion.append(question)
                
                // シード値変更
                seed++
                
                
                // 空の解答をAnswerDataにセット
                var questionAnswer: QuestionAnswer = QuestionAnswer()
                
                // 値をセット
                questionAnswer.questionText = "未解答"
                questionAnswer.mark = "未解答"
                println("obj\(obj+1)")
                // 追加作業
                QuestionAnswerBox.questionAnswerBoxInstance.studentAnswer.updateValue(questionAnswer, forKey: obj+1)
                
            }
            
            // 上でつくったものを保存
            QuestionBox.questionBoxInstance.questionID = selectQuestionListInt
            QuestionBox.questionBoxInstance.selectQuestion = selectQuestion
            QuestionBox.questionBoxInstance.selectQuestionRightAnswerList = rightAnswerList
            QuestionBox.questionBoxInstance.selectQuestionRightAnswerMarkList = rightAnswerMarkList
            
            
            self.delegate?.quizSelectQuestion?()
            
            // クイズ終了の通知
        case quizFinishUUID:
            let state: String = NSString(data: request.value, encoding:NSUTF8StringEncoding) as! String
            switch(state) {
            case "timerFinish":
                self.delegate?.goNextViewSegue?()
            case "quizFinish":
                self.delegate?.goNextViewSegue?()
            default :
                self.delegate?.goTopTableViewSegue?()
            }
            
            // SSアップロードリクエストの通知
        case monitoringUUID:
            screenShot()
            self.delegate?.ssUploadRequest?()
            
            // ロックリクエスト
        case lockUUID:
            let state: String = NSString(data: request.value, encoding:NSUTF8StringEncoding) as! String
            
            switch(state) {
                // 学生画面のロックを行う関数宣言とか
            case "lock":
                lockAlertView()
                println("lock you!!")
                
                
                // 学生画面のロックを解除する関数宣言とか
            case "unlock":
                dismissLockAlertView()
                
                println("unlock you!!")
                
                
            default:
                break
            }
            
            // サウンドエフェクトリクエスト
        case soundEffectUUID:
            let soundFile: String = NSString(data: request.value, encoding:NSUTF8StringEncoding) as! String
            
            SoundEffect.soundEffectInstance.soundPlay(soundFile)
            
            // クリッカーリクエスト Todo
        case clickerUUID:
            if let data: ClickerInfo = NSKeyedUnarchiver.unarchiveObjectWithData(request.value) as? ClickerInfo {
                ClickerInfo.clickerInfoInstance.setData(data)
                delegate?.clickerStart?("moodle")
            }
        case freeClickerUUID:
            let data: String = NSString(data: request.value, encoding:NSUTF8StringEncoding) as! String
            ClickerInfo.clickerInfoInstance.answerNumber = data.toInt()
            delegate?.clickerStart?("nomal")
            
        case clickerStatusUUID:
            let data: String = NSString(data: request.value, encoding:NSUTF8StringEncoding) as! String
            delegate?.clickerFinish?(data)
            
        case statusUUID:
            let status: String = NSString(data: request.value, encoding:NSUTF8StringEncoding) as! String
            if status != "finish" {
                self.delegate?.selectContent?(status)
            }
            else {
                self.delegate?.goTopTableViewSegue?()
            }
            
        case webUUID:
            if let data: WebInfo = NSKeyedUnarchiver.unarchiveObjectWithData(request.value) as? WebInfo {
                if data.url != nil {
                    delegate?.webGetedURL?(data.url!)
                }
                delegate?.webLock?(data.lockStatus!)
            }
            
        default:
            break
        }
    }
    
    
    
    
    // ----Delegate宣言----
    
    /**
    PMの筐体変化を取得
    */
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        println("State: \(peripheral.state.hashValue)")
        // 端末のBluetoothの状態を列挙
        enum CBPeripheralManagerState : Int {
            case Unknown
            case Resetting
            case Unsupported
            case Unauthorized
            case PoweredOff
            case PoweredOn
        }
        
        // 端末のBluetoothの状態によって作業を変更
        switch (peripheral.state){
        case .PoweredOn:
            // サービスの追加
            self.peripheralManager.addService(self.service)
            self.advertisementStart()
        case .PoweredOff:
            self.peripheralManager.removeService(self.service)
            self.advertisementStop()
            
        default:
            break
        }
        
    }
    
    
    /**
    Advertise開始処理結果を取得
    */
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager!, error: NSError!) {
        if (error != nil) {
            println("Failed... error: \(error)")
            return
        }
        println("アドバタイズ開始成功")
        
        
    }
    
    
    /**
    サービス追加結果を取得
    */
    func peripheralManager(peripheral: CBPeripheralManager!, didAddService service: CBService!, error: NSError!) {
        if(error != nil){
            println("サービス追加失敗 \(error)")
            return
        }
        
        println("サービス追加成功！")
        self.serviceFlag = true
    }
    
    
    /**
    Readリクエストに応答
    */
    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveReadRequest request: CBATTRequest!) {
        //        println("Readリクエスト受信しましたー！ requested service uuid: \(request.characteristic.service.UUID) characteristic uuid: \(request.characteristic.UUID) value: \(request.characteristic.value)")
        //        if request.characteristic.UUID.isEqual(self.characteristic.UUID) {
        // CBMutableCharacteristicのvalueをCBATTRequestのvalueにセット
        //            request.value = self.characteristic.value;
        //        }
        
        
        
        // ログインのreadリクエストだった場合
        if request.characteristic.UUID == loginUUID {
        }
        
        
        // 値をセット
        request.value = request.characteristic.value
        
        // リクエストに応答
        if request.offset > request.characteristic.value.length {
            self.peripheralManager.respondToRequest(request, withResult: CBATTError.InvalidOffset)
            return
        }
        request.value = request.characteristic.value.subdataWithRange(NSMakeRange(request.offset, request.characteristic.value.length - request.offset))
        
        self.peripheralManager.respondToRequest(request, withResult: CBATTError.Success)
        
    }
    
    
    /**
    Writeリクエストに応答
    */
    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveWriteRequests requests: [AnyObject]!) {
        println("Writeリクエスト受信しましたー！ ")
        
        for obj in requests {
            
            if let request = obj as? CBATTRequest {
                
                self.writeRequest(request)
                
                // todo
                //                if request.characteristic.UUID.isEqual(self.characteristic.UUID) {
                //                }
                // CBCharacteristicのvalueに、CBATTRequestのvalueをセット
                // self.characteristic.value = request.value;
            }
        }
        
        // リクエストに応答
        self.peripheralManager.respondToRequest(requests[0] as! CBATTRequest, withResult: CBATTError.Success)
    }
    
    
    /**
    Notify(Subscribe)リクエストに応答
    */
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!)
    {
        
        println("Subscribeリクエストを受信")
        let subscribeCharacteristic: CBMutableCharacteristic = self.characteristicList[characteristic.UUID]!
        println("Subscribe中のセントラル: \(subscribeCharacteristic.subscribedCentrals)")
        
        if self.centralList.updateValue(central, forKey: central.identifier) == nil {
            // 教員と接続した時の通知
            self.delegate?.connectTeacher?()
        }
        
        
    }
    
    
    /**
    Notify(unSubscribe)リクエストに応答
    */
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!)
    {
        //        self.peripheralViewDelegate.unSubscribe(self.characteristic.subscribedCentrals)
        println("Notify停止リクエストを受信")
        let subscribeCharacteristic: CBMutableCharacteristic = self.characteristicList[characteristic.UUID]!
        println("Notify中のセントラル: \(subscribeCharacteristic.subscribedCentrals)")
        
        self.centralList.removeAll(keepCapacity: true)
        self.delegate?.disconnectTeacher?()
    }
    
    
    /**
    Notifyを再送信
    */
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        if let data = self.sendDataList.first {
            self.peripheralManager.updateValue(data.data, forCharacteristic: data.characteristic, onSubscribedCentrals: nil)
            self.sendDataList.removeAtIndex(0)
        }
    }
    
}