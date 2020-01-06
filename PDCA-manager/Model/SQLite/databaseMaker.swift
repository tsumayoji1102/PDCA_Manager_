//
//  databaseMaker.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/29.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit
import FMDB

class databaseMaker: NSObject {

    
    override init() {
        super.init()
    }
    
    
    // DBパス取得
    private static func databaseFilePath() -> String {
        // パスを取得
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir   = paths[0] as NSString
        return dir.appendingPathComponent("app.db")
    }
    
    
    // DB取得
    static func getDatabase() -> FMDatabase! {
        let db = FMDatabase(path: databaseMaker.databaseFilePath())
        
        return db
    }

}
