//
//  DDL.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/19.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit
import FMDB

class DDL: NSObject {
    
    let db :         FMDatabase
    var createList : Array<String>?
    
    /** create sql **/
    
    let firstPlans =
    "CREATE TABLE IF NOT EXISTS first_plans (" +
    "plan_id         INTEGER PRIMARY KEY AUTOINCREMENT, " +
    "delete_flg      VARCHAR(1)  NOT NULL, " +
    "status_flg      VARCHER(1)  NOT NULL, " +
    "plan_name       VARCHAR(30) NOT NULL, " +
    "plan_start_date VARCHAR(19) NOT NULL, " +
    "plan_check_date VARCHAR(19) NOT NULL, " +
    "plan_end_date   VARCHAR(19) NOT NULL, " +
    "plan_comment    VARCHER(20), " +
    "plan_content    TEXT);"
    
    
    /** Initializer **/
    override init() {
        self.db = databaseMaker.getDatabase()
        super.init()
    }
    
    deinit {
        self.db.close()
    }
    
    
    // createするメソッド
    func createSql() -> Bool{
        
        if(self.db.open()){
          
        }else{
            print("createエラー、DDL: createSql")
            return false
        }
        
        createList = [firstPlans]
        
        let listCount = (createList?.count)! - 1
        
        for i in 0...listCount {
            self.db.executeUpdate(createList![i], withArgumentsIn: [])
            
            if(self.db.hadError()){
                getLog.getErrorLog(message: "create失敗、\(i)番目")
                return false
            }
        }
        
        return true
    }
    

}
