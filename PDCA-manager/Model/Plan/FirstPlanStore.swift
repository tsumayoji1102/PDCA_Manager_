//
//  FirstPlanStore.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/13.
//  Copyright © 2019年 塩見陵介. All rights reserved.
//



/**
 *
 *  Viewとデータをやり取りするためのファイル
 *
 *  readFirstPlan:    プランの読み出しに使う
 *  addNewPlan:       プランの追加に使う
 *  deletePlan:       プランの一つを削除する
 *  changeDeleteFlg:  終了したプランをでdelete_flg = 1にする
 *
 **/

import UIKit
import FMDB

class FirstPlanStore: NSObject {

    
    override init(){
        super.init()
    }
    
    deinit {
    }

    
    // Dao取得
    static private func connectDao() -> FirstPlanDao!{
        let db = databaseMaker.getDatabase()
        
        let open = db?.open()
        
        if (open!){
            let dao = FirstPlanDao.init(db: db!)
            return dao
            
        }else{
            getLog.getErrorLog(message: "dbエラー")
            return nil
        }
    }
    
    
    
    // 読み出し（検索含む）
    /**
     *
     *  @caseOfWord
     *    case 0 : 全体検索
     *    case 1 : プラン名検索
     *    case 2 : プラン内容検索
     *
     *
    **/
    static func readPlanList(caseOfRead: Int, searchWord: String!) -> Array<FirstPlan>!{
        
        var planList: Array<FirstPlan>!
        
        planList = connectDao()?.readFirstPlan(caseOfRead: caseOfRead, searchWord: searchWord)
        
        if (planList != nil) {
            getLog.getErrorLog(message: "読み出し失敗")
            return nil
        }
        
        return planList
    }
    
    
    
    
    // 追加
    static func addNewPlan(paramDic: Dictionary<String, String>) -> Bool{
        
        let insertSuccess = connectDao()?.insertFirstPlan(paramater: paramDic)
        
        if (insertSuccess != true){
            getLog.getErrorLog(message: "追加エラー")
            return false
        }else{
            getLog.getErrorLog(message: "追加成功")
            return true

        }
    }
    
    
    
    // 削除
    static func deletePlan(deletePlan: FirstPlan, planList: Array<FirstPlan>) -> Array<FirstPlan>!{
        
        let planId = String(deletePlan.planId)
        
        let deleteSuccess = connectDao()?.deleteFirstPlan(planId: planId)
        
        // dbが失敗したらreturnしない
        if(deleteSuccess != true){
            getLog.getErrorLog(message: "削除エラー")
            return nil
            
        }else{
            getLog.getErrorLog(message: "削除成功")
        }
        
        // 編集するリスト
        var newPlanList = planList
        
        for i in 1...planList.count - 1{
            if(planList[i].planId == deletePlan.planId){
                newPlanList.remove(at: i)
                break
            }
        }
        
        return newPlanList
    }
    
    
    
    // 終了日の来たものをdelete_flg = 1 にする
    static func changeDeleteFlg() -> Bool{
        
        let updateSuccess = connectDao()?.updateFirstPlans(parameter: nil, caseOfUpdate: 1)
        
        if(updateSuccess != true){
            getLog.getErrorLog(message: "終了エラー")
            return false
            
        }else{
            getLog.getErrorLog(message: "終了成功")
            return true
        }
    }
    
    
}
