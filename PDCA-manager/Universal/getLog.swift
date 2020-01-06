//
//  getLog.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/30.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit

class getLog {
    
    // エラーログを取得(メソッド)
    static func getLog(message:     Any = "",
                       function: String = #function,
                       file:     String = #file,
                       line:     Int    = #line)
    {
        
        let fileName = file
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        
        let now = dateFormatter.string(from: Date())
        
        Swift.print("\(fileName): \(function) \(message) (\(line)行目) \(now) ")
        
    }
    
    
    static func checkVCmethod(){
        
    }

}
