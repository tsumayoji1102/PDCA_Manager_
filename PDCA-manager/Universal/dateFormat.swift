//
//  dateFormat.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/30.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit

class dateFormat {
    
    // 秒単位で取得
    static func dateToString(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
        
    }
    
    
    //　Plan用の形式で取得
    static func dateToStringForPlan(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
        
    }
    
    //　Plan用の形式で取得
    static func dateToStringDayOnly(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
        
    }
    
    
    // StringToDate
    static func stringToDate(stringDate: String) -> Date!{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "dk_DK")
        
        if let returnDate = formatter.date(from: stringDate){
            return returnDate
        }else{
            return nil
        }
    }
    

}
