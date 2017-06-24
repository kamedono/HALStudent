//
//  ProfileImageView.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/23.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit


@IBDesignable
class ProfileView: UIView {
    @IBOutlet weak var profileImage: UIImageView!
    
    var number: Int!
    
    /**
    コードで初期化した場合
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    /**
    xib,Storyboardで初期化した場合
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    // プロパティに画像追加
    @IBInspectable var image: UIImage? {
        didSet {
            self.profileImage.image = image
        }
    }

    // プロパティに名前追加
    @IBInspectable var radius: CGFloat? {
        didSet {
            self.profileImage.layer.cornerRadius = radius!
            self.profileImage.layer.masksToBounds = true
        }
    }

    
    /**
    xibからカスタムViewを読み込んで準備する
    */
    private func comminInit() {
        self.profileImage.layer.cornerRadius = 100
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "Profile", bundle: bundle)
        
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(0),
            metrics:nil,
            views: bindings))
    }
    
    
    /**
    プロフィール情報を設定
    */
    func setProfile(imageName: UIImage) {
            self.profileImage.image = image
    }
    
        
    
    /**
    Viewをタッチした時のデリゲート
    */
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        super.touchesEnded(touches, withEvent: event)
        
        for touch: AnyObject in touches {

        }
    }
    
}