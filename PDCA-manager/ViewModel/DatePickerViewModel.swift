//
//  DatePickerViewModel.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/12/05.
//  Copyright © 2019 塩見陵介. All rights reserved.
//


import UIKit

class DatePickerViewModel: NSObject {
    
    // 生成当初は現在時刻
    override init(){
        super.init()
    }
    
    deinit {
    }
    
    // Viewの保持する日付
    static var selectedDate: Date!
    

}
