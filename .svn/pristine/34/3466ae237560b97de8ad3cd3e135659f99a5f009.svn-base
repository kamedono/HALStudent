//
//  SoundEffect.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/07.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class SoundEffect: NSObject, AVAudioPlayerDelegate {
    static var soundEffectInstance = SoundEffect()

    var audio : AVAudioPlayer!

    
    func soundPlay(name: String) {
        //音楽ファイルのパス取得
        let audioFilePath : NSString = NSBundle.mainBundle().pathForResource(name, ofType: "mp3")!
        let audiofileURL : NSURL = NSURL(fileURLWithPath: audioFilePath as String)!
        
        //AVAudioPlayerのインスタンス化.
        self.audio = AVAudioPlayer(contentsOfURL: audiofileURL, error: nil)
        
        self.audio.delegate = self
        
        self.audio.play()
    }

}