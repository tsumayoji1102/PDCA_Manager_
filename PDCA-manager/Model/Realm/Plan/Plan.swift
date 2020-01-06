//
//  Plan.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/12/24.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import RealmSwift

class Plan: Object {
    
    @objc dynamic var planId:         Int      = 0
    @objc dynamic var statusFlg:      String   = "0"
    @objc dynamic var planName:       String   = ""
    @objc dynamic var planContent:    String   = ""
    @objc dynamic var planComment:    String   = ""
    @objc dynamic var planStartDate:  Date     = Date()
    @objc dynamic var planCheckDate:  Date     = Date()
    @objc dynamic var planEndDate:    Date     = Date()
    
    // プライマリーキー
    override static func primaryKey() -> String? {
        return "planId"
    }
    
}
