//
//  CoreData_module.swift
//  CoreData_mocup
//
//  Created by sotuken on 2015/07/13.
//  Copyright (c) 2015年 sotuken. All rights reserved.
//

import UIKit
import CoreData

class CoreData_module {
    //教員側
    //学生カラムの作成
    func add_Student(){
        // AppDelegateクラスのインスタンスを取得
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // ①保存するもの（Contextインスタンス作成）
        let studentContext: NSManagedObjectContext = appDel.managedObjectContext!
        // NSEntityDescriptionから新しいエンティティモデルのインスタンスを取得
        // 第一引数はモデルクラスの名前、第二引数はNSManagedObjectContext
        let studentEntity: NSEntityDescription! = NSEntityDescription.entityForName("Student", inManagedObjectContext: studentContext)
        var Student_Data = Student(entity: studentEntity, insertIntoManagedObjectContext: studentContext)
        
        //データの挿入
        Student_Data.id = StudentInfo.studentInfoInstance.userID!
        Student_Data.name = StudentInfo.studentInfoInstance.name!
        
        println(Student_Data)
        
        var error: NSError?
        //挿入したデータをエンティティに保存
        if !studentContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    //問題カラムの作成
    func add_question(questionID: String){
        //お約束
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let questionContext: NSManagedObjectContext = appDel.managedObjectContext!
        let questionEntity: NSEntityDescription! = NSEntityDescription.entityForName("Question", inManagedObjectContext: questionContext)
        //このインスタンスにデータを入れ込む
        var Question_Data = Question(entity: questionEntity, insertIntoManagedObjectContext: questionContext)
        
        //問題IDの挿入
        Question_Data.q_id = StudentInfo.studentInfoInstance.userID!
        
        //問題を学生の情報を入れる（Studentインスタンスを入れる）
        // Studentの検索
        if let managedObjectContext = appDel.managedObjectContext {
            let Student_Data = NSEntityDescription.entityForName("Student", inManagedObjectContext: managedObjectContext);
            // NSFetchRequest SQLのSelect文のようなイメージ
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = Student_Data;
            // NSPredicate SQLのWhere句のようなイメージ
            let predicate = NSPredicate(format: "id = %@", StudentInfo.studentInfoInstance.userID!)
            println(predicate)
            fetchRequest.predicate = predicate
            
            var error: NSError? = nil;
            
            // フェッチリクエストの実行(whereの条件をみたす物を探す)
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                println(results)
                //                println(Student)
                for managedObject in results {
                    //検索でヒットした学生のインスタンスを代入
                    Question_Data.student = (managedObject as? Student)!;
                }
            }
            //Contextの内容を保存する
            if !questionContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
        println(Question_Data)
        
    }
    
    //学生が解いた問題カラムの更新
    func update_question(user_id:String, q_id:String, answer:String, judge:Bool){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var p_key : NSString? //学生のプライマリキー
        if let managedObjectContext = appDelegate.managedObjectContext {
            //学生名からプライマリキーを取得
            //学生インスタンスの作成
            let studentDiscription = NSEntityDescription.entityForName("Student", inManagedObjectContext: managedObjectContext);
            let fetchRequest_student = NSFetchRequest();
            fetchRequest_student.entity = studentDiscription;
            // user_idの内容と合致するカラムを探す（SQL）
            let predicate_student = NSPredicate(format: "id = %@",user_id)
            fetchRequest_student.predicate = predicate_student
            
            var error: NSError? = nil;
            // フェッチリクエストの実行
            if var results_student = managedObjectContext.executeFetchRequest(fetchRequest_student, error: &error) {
                for managedObject in results_student {
                    //Z_PKの表示(Studentのプライマリキー)
                    p_key = managedObject.objectID.description
                    println(p_key)
                    var p_key_separate = p_key!.componentsSeparatedByString("/")
                    //println()(p_kry_separate[4]) //p6>
                    p_key = ((p_key_separate[4] as! NSString).substringFromIndex(1)) // 6> :先頭文字削除
                    println(p_key)
                    p_key = p_key!.substringToIndex(1) // 6 :先頭文字抽出
                    println(p_key)
                }
            }
            //プライマリキーに該当する学生の回答を更新
            // Questionインスタンスを生成
            let questionDiscription = NSEntityDescription.entityForName("Question", inManagedObjectContext: managedObjectContext);
            // NSFetchRequest SQLのSelect文のようなイメージ
            let fetchRequest_question = NSFetchRequest();
            fetchRequest_question.entity = questionDiscription;
            // NSPredicate SQLのWhere句のようなイメージ
            let predicate_question = NSPredicate(format: "q_id = %@ and student = %@",q_id ,p_key!)
            fetchRequest_question.predicate = predicate_question
            
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest_question, error: &error) {
                for managedObject in results {
                    
                    //Questionの方に変換
                    let question = managedObject as! Question;
                    
                    // レコードの更新！
                    question.answer = answer
                    question.judge = judge
                }
                // AppDelegateクラスに自動生成された saveContext で保存完了
                appDelegate.saveContext()
            }
            
        }
    }
    
    //学生テーブルの全件削除（idに値のあるカラムを削除する＝＝全てのカラム）
    func delete_student (){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let Discription = NSEntityDescription.entityForName("Student", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = Discription;
            // idがnull以外の物は全て該当する
            let predicate = NSPredicate(format: "id != %@","null")
            fetchRequest.predicate = predicate
            
            var error: NSError? = nil;
            
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    //削除処理
                    let student = managedObject as! Student;
                    managedObjectContext.deleteObject(student);
                }
                // AppDelegateクラスに自動生成された saveContext で保存完了
                appDelegate.saveContext()
                //削除を知らせるアラート
                var alert = UIAlertView()
                alert.title = "deleted students"
                alert.message = "deleted students"
                alert.addButtonWithTitle("OK")
                alert.show()
            }
        }
    }
    
    //問題テーブルの全件削除（q_idに値のあるカラムを削除する＝＝全てのカラムを削除）
    func delete_question (){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let Discription = NSEntityDescription.entityForName("Question", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = Discription;
            // q_idがnull以外の物は全て該当する
            let predicate = NSPredicate(format: "q_id != %@","null")
            fetchRequest.predicate = predicate
            
            var error: NSError? = nil;
            
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    //削除処理
                    let question = managedObject as! Question;
                    managedObjectContext.deleteObject(question);
                }
                // AppDelegateクラスに自動生成された saveContext で保存完了
                appDelegate.saveContext()
                //削除を知らせるアラート
                //                var alert = UIAlertView()
                //                alert.title = "deleted questions"
                //                alert.message = "deleted questions"
                //                alert.addButtonWithTitle("OK")
                //                alert.show()
            }
            
        }
    }
    
    //使うかわからないモジュールたち
    //学生一覧の表示
    func show_all_student (){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let studentDiscription = NSEntityDescription.entityForName("Student", inManagedObjectContext: managedObjectContext);
            let fetchRequest_student = NSFetchRequest();
            fetchRequest_student.entity = studentDiscription;
            // student_qの内容と合致するカラムを探す（SQL）
            let predicate_student = NSPredicate(format: "name != %@","null")
            fetchRequest_student.predicate = predicate_student
            
            var error: NSError? = nil;
            
            // フェッチリクエストの実行
            if var results_student = managedObjectContext.executeFetchRequest(fetchRequest_student, error: &error) {
                for managedObject in results_student {
                    //Studentの方に変換
                    let student = managedObject as! Student;
                    var result = "id ="+student.id + "  name =" + student.name
                    println(result)
                    //lists.append(result ?? "null")//nilだったら ??"この文字を代入する"
                }
                // AppDelegateクラスに自動生成された saveContext で保存完了
                appDelegate.saveContext()
            }
            
        }
    }
    
    //学生テーブルのカラム数を返す
    func student_num() -> (Int){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext!
        var error: NSError? = nil;
        let fetchRequest_s = NSFetchRequest(entityName: "Student")
        let s_cnt = managedObjectContext.countForFetchRequest(fetchRequest_s, error: &error)
        println((s_cnt))
        return s_cnt;
    }
    
    //問題テーブルのカラム数を返す(問題の数*学生数)
    func question_num() -> (Int){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext: NSManagedObjectContext = appDel.managedObjectContext!
        var error: NSError? = nil;
        let fetchRequest_q = NSFetchRequest(entityName: "Question")
        let q_cnt = managedObjectContext.countForFetchRequest(fetchRequest_q, error: &error)
        println((q_cnt))
        return q_cnt;
    }
    //問題数 ＝ question_num / student_numで求めることができる
    
    
    
}