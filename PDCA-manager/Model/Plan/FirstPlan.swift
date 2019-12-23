//
//  FirstPlan.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/13.
//  Copyright © 2019年 塩見陵介. All rights reserved.
//

import UIKit

class FirstPlan: NSObject {
    
    /**
    *
    *
    **/
    
    private(set) var planId:         Int
    private(set) var statusFlg:      String
    private(set) var planName:       String
    private(set) var planContent:    String!
    private(set) var planComment:    String!
    private(set) var planStartDate:  String
    private(set) var planCheckDate:  String
    private(set) var planEndDate:    String
    
    
    
    // 最低限を満たしたインスタンス
    init(planId: Int, statusFlg: String, planName: String, planStartDate: String, planCheckDate: String ,planEndDate: String) {
        
        self.planId         = planId
        self.statusFlg      = statusFlg
        self.planName       = planName
        self.planStartDate  = planStartDate
        self.planCheckDate  = planCheckDate
        self.planEndDate    = planEndDate
    }
    
    
    // 内容を入れた際のやつ
    init(planId: Int, statusFlg: String, planName: String, planContent: String, planComment: String, planStartDate: String, planCheckDate: String,planEndDate: String) {
        
        self.planId        = planId
        self.statusFlg     = statusFlg
        self.planName      = planName
        self.planContent   = planContent
        self.planComment   = planComment
        self.planStartDate = planStartDate
        self.planCheckDate = planCheckDate
        self.planEndDate   = planEndDate
    }
    

}
