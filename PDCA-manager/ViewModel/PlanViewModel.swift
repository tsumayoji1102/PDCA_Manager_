//
//  addPlanViewModel.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/12/24.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit

class PlanViewModel: NSObject{
    
    let planDao: PlanDao!
    
    override init(){
        planDao = PlanDao.init()
        super.init()
    }
    
    // プラン追加
    func addNewPlan(dic: Dictionary<String, Any?>) -> Bool{
        
        // 採番を行う
        let newPlanId     = planDao.getNewPlanId()
        var newDic        = dic
        
        newDic["plan_id"] = newPlanId
        let addSuccess = planDao.createPlan(dic: newDic)
        
        return addSuccess
    }
    
    
    // プラン読み込み
    func readPlan(type: String, word: String!, compare: String!) -> Array<Plan>!{
        
        let list = planDao.readPlan(type:type, word:word, compare:compare)!
        
        var planList = Array<Plan>()
        
        for plan in list{
            planList.append(plan)
        }
        
        if(planList.count == 0){
            return nil
        }
        
        return planList
        
    }
    

    
    

}
