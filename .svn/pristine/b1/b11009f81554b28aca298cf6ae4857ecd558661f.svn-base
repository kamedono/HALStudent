//
//  NominationSimpleViewController.swift
//  HALStudent
//
//  Created by Toshiki Higaki on 2015/09/21.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import CoreData

class NominationSimpleViewController: UIViewController, UIScrollViewDelegate, MenuViewDelegate, QCheckViewControllerDelegate, FinishFunctionDelegate, CorePeripheralManagerDelegate {
    private var currentIndex = 0
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var menuView: MenuView!
    
    //ViewControllerS
    var vcs :Array<UIViewController>! = []
    
    //問題たち
    //    var questions :QuestionBox!
    var menus: Array<MenuElem> = []
    
    //学生データ
    //    var studentData :StudentData!
    
    //CoreData
    var coreData :CoreData_module!
    
    //リストのlengthを格納
    var mc = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //これがないと解答一覧画面に行けない
        self.contentScrollView.bounces = true
        
        //配列の数 length
        self.mc = menus.count
        println(menus.count.description)
        self.menuView.setup(menus, delegate:self)
        self.setupContentScrollView(menus)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //someviewをサブビューとして扱う
        
        self.contentScrollView.contentSize =
            CGSizeMake(CGFloat(self.vcs.count) * self.contentScrollView.frame.width,
                self.contentScrollView.frame.height-100)
        
        
        var cnt = 0
        let rect = self.contentScrollView.frame
        
        // subViewの取得
        for view in self.contentScrollView.subviews as! [UIView] {
            view.frame = CGRectMake(CGFloat(cnt) * rect.width, 0, rect.width, rect.height)
            cnt++
        }
        
        self.scrollToPage(self.menuView.pageControl.currentPage)
        self.view.layoutSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: true)

        CorePeripheralManager.corePeripheralInstance.finishFunction.delegate = self
        CorePeripheralManager.corePeripheralInstance.delegate = self
    }
    
    /**
    contentScrollViewのページのセットアップ
    
    :param: menus
    */
    func setupContentScrollView(menus: Array<MenuElem>) {
        for var menuCount = 0; menuCount < menus.count; menuCount++ {
            println(menuCount)
            // storyBoard <- UIStoryBoard
            // instantiateViewControllerWithIdentifier <- 指定したStoryBoardIDから,ViewController を生成する
            // as! UIViewController
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("testView") as! SomeViewController
            // 変数の代入
            //            viewController.delegate = self
            viewController.menu = menus[menuCount]
            viewController.question = QuestionBox.questionBoxInstance.selectQuestion[menuCount]
            //            viewController.coreData = coreData
            //            viewController.studentData = studentData
            // scrollViewに追加
            self.contentScrollView.addSubview(viewController.view)
            self.vcs.append(viewController)
        }
    }
    
    /**
    contentScrollViewのページを遷移させる
    
    :param: newPage ページ番号
    */
    func scrollToPage(newPage :Int) {
        let scrollViewRect = self.contentScrollView.frame
        // 場所を決める
        let visibleRect = CGRectMake(CGFloat(newPage) * scrollViewRect.width,scrollViewRect.origin.y, scrollViewRect.width, scrollViewRect.height)
        // スクロールさせる
        self.contentScrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    //スクロールした時に呼び出される
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var currentPage = self.menuView.pageControl.currentPage
        
        let pageWidth = scrollView.frame.width
        
        //　ページのインデックス
        let newPage = floor((scrollView.contentOffset.x - pageWidth * 0.1 ) / pageWidth ) + 1
        // 最後のページのとき
        if(Int(newPage) == mc){
            self.performSegueWithIdentifier("goToNext", sender: self)
        }else{
            self.menuView.changePage(Int(currentPageIndex(contentScrollView)), needScrollToVisible: true)
        }
    }
    
    
    @IBAction func goToAnswerCheck(sender: AnyObject) {
        self.performSegueWithIdentifier("goToNext", sender: self)
    }
    
    
    // ページ遷移をする際に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goToNext") {
            let qCheck: QCheckViewController = segue.destinationViewController as! QCheckViewController
            //問題数
            qCheck.questionNum = menus.count
            //問題情報
            //            qCheck.questions = questions
            //            qCheck.studentData = studentData
            qCheck.delegate = self
        }
    }
    
    /**
    現在のページ番号を取得
    */
    private func currentPageIndex(scrollView : UIScrollView) -> CGFloat{
        let width  = CGRectGetWidth(scrollView.frame)
        let maxPageIndex = menus.count
        let positionX = scrollView.contentOffset.x
        var paging = round(positionX / width)
        if(paging < 0.0){
            paging = 0.0
        }
        if(paging > CGFloat(maxPageIndex)){
            paging = CGFloat(maxPageIndex)
        }
        return paging
    }
    
    //上のバーで操作したとき
    func menuViewDidScroll(sender: MenuView) {
        self.scrollToPage(sender.pageControl.currentPage)
    }
    
    
    
    
    // --------デリゲート--------
    
    
    /**
    QCheckViewControllerDelegate
    ページ番号が通知される
    
    :param: newPage ページ番号
    */
    func popToQuestion(newPage: Int) {
        // MenuViewの番号をnewPageで指定したものに
        self.menuView.changePage(newPage, needScrollToVisible: true)
        // newPageで指定した番号にページ遷移
        // contentScrollView
        self.scrollToPage(newPage)
    }
    
    /**
    結果画面に行って欲しいときに通知されるデリゲート
    */
    func goNextViewSegue() {
        self.performSegueWithIdentifier("goNominationResultViewSegue", sender: nil)
    }
    
    /**
    コンテンツ終了のデリゲート
    */
    func goTopTableViewSegue() {
        self.performSegueWithIdentifier("goTopTableViewSegue", sender: nil)
    }
}
