//
//  planDao.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/12/24.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit
import RealmSwift

class PlanDao: NSObject{
    
    // realmを保持
    let realm : Realm
    
    override init(){
        realm = try! Realm()
        super.init()
    }
    
    // planIdの採番
    func getNewPlanId() -> Int{
        
        let result = realm.objects(Plan.self).sorted(byKeyPath: "planId", ascending: false)
        
        let maxIdPlan = result[0]
        return maxIdPlan.planId + 1
    }
    
    
    // create
    func createPlan(dic: Dictionary<String, Any?>) -> Bool{
        
        let newPlan = Plan()
        
        newPlan.planId        = dic["plan_id"]         as! Int
        newPlan.planName      = dic["plan_name"]       as! String
        newPlan.planContent   = dic["plan_content"]    as! String
        newPlan.planComment   = dic["plan_comment"]    as! String
        newPlan.planStartDate = dic["plan_start_date"] as! Date
        newPlan.planCheckDate = dic["plan_check_date"] as! Date
        newPlan.planEndDate   = dic["plan_end_date"]   as! Date
        
        try! realm.write {
            realm.add(newPlan)
            getLog.getLog(message: "realm.write true")
        }

        return true
    }
    
    
    
    /**
    * type:     検索の絞り
    * word:     検索ワード（必要ないものもある）
    * compare:  比較演算子(=, <, >, <=, >=)
     **/
    
    func readPlan(type: String, word: String!, compare: String!) -> Results<Plan>!{
        
        switch type {
        case "all":
            let list = realm.objects(Plan.self)
            return list
            
        case "plan_id":
            let list = realm.objects(Plan.self).filter("planId %@  %@", compare, Int(word)!)
            return list
            
        case "plan_name":
            let list = realm.objects(Plan.self).filter("planName %@ %@", compare, word)
            return list
          
        case "plan_start_date":
            let date = dateFormat.stringToDate(stringDate: word)
            let list = realm.objects(Plan.self).filter("planStartDate %@ %@", compare, date!)
            return list
            
        case "plan_end_date":
            let date = dateFormat.stringToDate(stringDate: word)
            let list = realm.objects(Plan.self).filter("planEndDate %@ %@", compare, date!)
            return list
            
        default:
            return nil
        }
    }
    
    
    // Update
    func updatePlan(type: String, plan: Plan, value: Any) -> Bool{
        
        var updateOK = true
        
        try! realm.write {
            switch type{
            case "plan_id":
                plan.planId        = value as! Int
                break
                
            case "plan_name":
                plan.planName      = value as! String
                break
            
            case "plan_content":
                plan.planContent   = value as! String
                break
                
            case "plan_comment":
                plan.planComment   = value as! String
                break
                
            case "plan_start_date":
                plan.planStartDate = value as! Date
                break
                
            case "plan_check_date":
                plan.planCheckDate = value as! Date
                break
                
            case "plan_end_date":
                plan.planEndDate   = value as! Date
                break
                
            default:
                updateOK = false
                break
                
               }
        }
        return updateOK
        
    }
    
    // Delete
    func deletePlan(plan: Plan) -> Bool{
        
        try! realm.write{
            realm.delete(plan)
        }
        return true
        
    }

}
