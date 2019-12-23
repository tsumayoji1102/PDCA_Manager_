//
//  DatePickerViewController.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/11/16.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePickerForButton: UIDatePicker!
    @IBOutlet weak var settingButton:       UIButton!
    @IBOutlet weak var closeButton:         UIButton!
    @IBOutlet weak var OKButton:            UIButton!
    
    // 保持する値
    var segueButtonName:    String!  // 取得ボタン名
    var settingButtonTitle: String!  // 1週間後に設定
    var currentButtonDate:  Date!    // 取得先ボタンのDate(タップ時)
    var presentingVC:       UIViewController! // 遷移元VC
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame.size.width = UIScreen.main.bounds.size.width - 20
        

        settingButton.addTarget(self, action: #selector(tapDecideSevenDays(_:)), for: UIControl.Event.touchUpInside)
        
        let locale = Locale.init(identifier: "dk_DK")
        datePickerForButton.locale = locale

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // currentButtonDateを取得
        currentButtonDate = getCurrentButtonDate()
        
        print("currentDate: " + dateFormat.dateToString(date: currentButtonDate) )
        
        // ボタンのDateをDatepickerに設定
        datePickerForButton.date = currentButtonDate
    }
    
    
    
    
    // MARK: - Object Method
    
    // ×ボタン設定
    @IBAction private func tapClose(_ sender: UIButton) {
        
        selectVCForDismiss(setDate: false)
    }
    
    
    
    
    // 日付設定時
    @IBAction private func decideDate(_ sender: UIDatePicker) {
        
        switch segueButtonName {
        case "planCheckDate":
            // 今日より前の日を指定した際は非活性
            OKButton.isEnabled = sender.date < Date() ? false: true
            break
            
        case "planEndDate":
            // 今日より前の日を指定した際は非活性
            OKButton.isEnabled = sender.date < Date() ? false: true
            break
        default:
            break
        }
        
    }
    
    
    // OKボタン押下時
    @IBAction private func tapOK(_ sender: UIButton) {
        
        selectVCForDismiss(setDate: true)
        
    }
    
    
    // settingButton設定時(一週間後に設定)
    @objc private func tapDecideSevenDays(_ button: UIButton){
        
        //let nowDate = Date()
        
        let sevenDate = Calendar.current.date(bySetting: .day, value: 7, of: currentButtonDate)
        
        datePickerForButton.date = sevenDate!
        
    }
    
    
    
    // MARK: - Method
    
    // ボタンの日を取得(うまく行ってない)
    func getCurrentButtonDate() -> Date{
        
        presentingVC = self.presentingViewController
        
        if presentingVC == presentingVC as? addPlanViewController{
            
            let VC = presentingVC as? addPlanViewController
            
            // ボタンで判定
            switch segueButtonName {
            case "planCheckDate":
                guard (VC!.planCheckDate != nil) else{
                    return Date()
                }
                return VC!.planCheckDate
                
            case "planEndDate":
                guard (VC!.planEndDate != nil) else{
                    return Date()
                }
                return VC!.planEndDate
                
            default:
                return Date()
            }
            
        }
        
        return Date()
        
    }
    
    
    
    // 遷移直前の処理
    func selectVCForDismiss(setDate: Bool){
        // 遷移元を取得
        presentingVC = self.presentingViewController
        
        // 遷移元で分岐
        if presentingVC == presentingVC as? addPlanViewController{
            
          let VC = presentingVC as? addPlanViewController
            
          if (VC?.opacityBackground != nil){
                VC?.opacityBackground.isHidden = true
          }
            
          // 日付をセットしない場合
          if !setDate{
            // 前の画面に遷移
            self.dismiss(animated: true, completion: {})
          }
            
          // 値をセット
          let returnDate = datePickerForButton.date
            
          // Stringに変換
          let dateToString1 = dateFormat.dateToStringForPlan(date: returnDate)
            
          print("dateToString1:" + dateToString1)
            
          // ボタンによって分岐
          switch segueButtonName {
              case "planCheckDate":                VC?.planCheckDateButton.setTitle(dateToString1, for: .normal)
                  VC!.planCheckDate = returnDate
                  break
                
              case "planEndDate":          VC?.planEndDateButton.setTitle(dateToString1, for: .normal)
                  VC!.planEndDate = returnDate
                  break
                
              default:
                  break
          }
        }
        
        // 前の画面に遷移
        self.dismiss(animated: true, completion: {
        })
    }
    
}
