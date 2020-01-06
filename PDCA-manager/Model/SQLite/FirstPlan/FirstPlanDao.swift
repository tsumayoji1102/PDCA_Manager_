//
//  FirstPlanDao.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/13.
//  Copyright © 2019年 塩見陵介. All rights reserved.
//

import UIKit
import FMDB

class FirstPlanDao: NSObject {
    
    
    // dbのインスタンス
    private let db: FMDatabase
    
    
    // イニシャライザ
    init(db: FMDatabase){
        self.db = db
        super.init()
    }
    
    
    // インスタンスの破棄
    deinit {
        self.db.close()
        print("dbクローズ（FirstPlanDao）")
    }
    
    
    
    // Select
    func readFirstPlan(caseOfRead: Int, searchWord: String!) ->Array<FirstPlan>!{
        
        var FirstPlans = Array<FirstPlan>()
        
        
        var readSql =
        "SELECT * FROM first_plans " +
        "WHERE delete_flg = 0 "
        
        // パターンによって検索を変える
        switch caseOfRead {
        // すべて参照
        case 0:
            break
        
        // プラン名検索
        case 1:
            let nameSql = "AND plan_name like '%" + searchWord + "%' "
            readSql += nameSql
            break
        
        // 内容検索
        case 2:
            let contentSql = "AND plan_content like '%" + searchWord + "%' "
            readSql += contentSql
            break
            
        default:
            getLog.getLog(message: "検索エラー")
            return nil
        }
        
        // 並び替え（終了日が早い順）
        let orderSql = "ORDER BY plan_end_date ASC;"
        
        
        // 完成系SQL
        readSql += orderSql
        
        
        if let results = self.db.executeQuery(readSql, withArgumentsIn: []){
            while results.next(){
                
                // インスタンス生成
                let firstPlan = FirstPlan(
                    planId:        results.long(forColumn:   "plan_id"),
                    statusFlg:     results.string(forColumn: "status_flg")!,
                    planName:      results.string(forColumn: "plan_name")!,
                    planContent:   results.string(forColumn: "plan_content")!,
                    planComment:   results.string(forColumn: "plan_comment")!,
                    planStartDate: results.string(forColumn: "plan_start_date")!,
                    planCheckDate: results.string(forColumn: "plan_check_date")!,
                    planEndDate:   results.string(forColumn: "plan_end_date")!
                )
                // 配列に追加
                FirstPlans.append(firstPlan)
                
            }
        
        // エラーだった際には
        }else if(self.db.hadError()){
            getLog.getLog(message: "dbエラー")
            return nil
        }
        
        return FirstPlans
    }
    
    
    
    
    // Update
    func updateFirstPlans(parameter: Dictionary<String, String>!, caseOfUpdate: Int) ->Bool{
        
        // 通常のUpdate
        if(caseOfUpdate == 0){
            
            let updateSql =
            "UPDATE first_plans "   +
            "SET delete_flg  = ?, " +
            "status_flg      = ?, " +
            "plan_name       = ?, " +
            "plan_content    = ?, " +
            "plan_comment    = ?, " +
            "plan_check_date = ?, " +
            "plan_end_date   = ? "  +
            "WHERE plan_id = ?;"
            
            self.db.executeUpdate(updateSql, withArgumentsIn: [
                parameter["delete_flg"]!,
                parameter["status_flg"]!,
                parameter["plan_name"]!,
                parameter["plan_content"]!,
                parameter["plan_comment"]!,
                parameter["plan_check_date"]!,
                parameter["plan_end_date"]!,
                parameter["plan_id"]!
                ])
            
            if(self.db.hadError()){
                getLog.getLog(message: "dbエラー")
                return false
            }
         
        // 終了日がきた日だけ、deleteFlg
        }else if(caseOfUpdate == 1){
            
            let updateDeleteFlgSql =
            "UPDATE first_plans SET delete_flg = 1 WHERE plan_end_date > ?"
            
            let today = Date()
            
            self.db.executeUpdate(updateDeleteFlgSql, withArgumentsIn:[today])
            
            if(self.db.hadError()){
                getLog.getLog(message: "dbエラー")
                return false
            }
        }
       
        return true
    }
    
    
    
    
    // Insert
    func insertFirstPlan(paramater: Dictionary<String, String>) -> Bool{
        
        let insertSql =
        "INSERT INTO" +
        "first_plans(plan_name, status_flg, plan_content, plan_comment, plan_start_date, plan_check_date, plan_end_date, delete_flg)" +
        "VALUES(?, ?, ?, ?, ?, ?, ?, ?);"
        
        self.db.executeUpdate(insertSql, withArgumentsIn:
            [paramater["plan_name"]!,
             paramater["status_flg"]!,
             paramater["plan_content"]!,
             paramater["plan_comment"]!,
             paramater["plan_start_date"]!,
             paramater["plan_check_date"]!,
             paramater["plan_end_date"]!,
             paramater["delete_flg"]!])
        
        if(self.db.hadError()){
            getLog.getLog(message: "dbエラー")
            return false
        }
        
        return true
    }
    
    
    
    // Delete
    func deleteFirstPlan(planId: String) ->Bool{
        
        let deleteSql =
        "DELETE FROM first_plans WHERE plan_id = ?"
        
        self.db.executeUpdate(deleteSql, withArgumentsIn: [planId])
        
        if(self.db.hadError()){
            getLog.getLog(message: "dbエラー")
            return false
        }
        
        return true
    }
    
    
    
}
