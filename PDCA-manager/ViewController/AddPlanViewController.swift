//
//  addPlanViewController.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/31.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit


class AddPlanViewController: UIViewController{
    
    // table用
    enum tableContents: Int{
        case planName  = 0,
             planContent,
             planComment,
             planCheckDate,
             planEndDate,
             planDecideButton,
             tableContentNum
    }
    
    enum buttonName: Int{
        case startDate = 0,
             endDate
    }
    
    // Viewパーツ
    @IBOutlet weak var addPlanNavigation: UINavigationItem!
    @IBOutlet weak var addPlanNavi:       UINavigationBar!
    @IBOutlet weak var cancelButton:      UIButton!
    @IBOutlet weak var doneButton:        UIButton!
    @IBOutlet weak var addPlanTable:      UITableView!
    
    // 追加パーツ
    private var planNameTf:               UITextField!
    private var planContentTf:            UITextField!
    private var planCommentTf:            UITextField!
    private var planDecideButton:         UIButton!
    var planCheckDateButton:              UIButton!
    var planEndDateButton:                UIButton!
    var opacityBackground:                UIView!
    
    // addPlanViewModel
    let planViewModel = PlanViewModel.init()
    
    // ボタンの保持する値
    var planCheckDate:                    Date!
    var planEndDate:                      Date!
    // Done判定
    var doneOk = false
    
    
    // メイン
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarの高さを合わせる
        let margin       = getSize.usefulSize(UIView: nil)["statusBarHeight"]
        let screenHeight  = UIScreen.main.bounds.size.height
        let screenWidth   = UIScreen.main.bounds.size.width
        
        self.addPlanNavi.frame = CGRect.init(x: 0, y: margin!, width: screenWidth, height: 44)
        
        
        // navigation設定
        addPlanNavigation.title = "プラン追加"
        
        
        // ボタン設定
        cancelButton.addTarget(self, action: #selector(addPlanViewController.tapCancelButton), for: .touchUpInside)
        
        doneButton.addTarget(self, action: #selector(addPlanViewController.tapDoneButton), for: .touchUpInside)
        doneButton.isEnabled = false
        
        
        // テーブル設定
        addPlanTable.frame = getSize.getScreenSize(naviHeight: addPlanNavi.frame.height)
        addPlanTable.separatorStyle  = .none
        addPlanTable.delegate        = self
        addPlanTable.dataSource      = self
        addPlanTable.allowsSelection = false
        
        view.addSubview(addPlanTable)
        
        
        
        // 影の背景をつける（非活性）
        opacityBackground = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight))
        opacityBackground.backgroundColor = UIColor.black
        opacityBackground.alpha = 0.3
        opacityBackground.isHidden = true
        
        view.addSubview(opacityBackground)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    // MARK: - @objc Action
    
    // cancelボタン押下時
    @objc private func tapCancelButton(_ sender: UIButton){
        
        // 前の画面に遷移
        self.dismiss(animated: true, completion: nil)
    }
    
    // doneボタン押下時
    @objc private func tapDoneButton(_ sender: UIButton){
        
        // dic作成
        let dic: Dictionary<String, Any?>
            = ["plan_name"   :    planNameTf.text,
               "plan_content":    planContentTf.text,
               "plan_start_date": Date(),
               "plan_check_date": planCheckDate,
               "plan_end_date":   planEndDate
                ]
        
        // データ追加
        let bool = planViewModel.addNewPlan(dic: dic)
        
        if(bool){
            
            // 前の画面に遷移
            self.dismiss(animated: true, completion: nil)
        
        // できなかった際はエラー
        }else{
            let alert: UIAlertController = UIAlertController(title: "追加失敗", message: "エラーによりプランの追加に失敗しました。", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) -> Void in
                print("OK")})
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    // datePickerViewを開く
    @objc private func tapSelectDate(_sender: UIButton){
        
        print(_sender.tag)
        
        // タグによって保持する値を変える
        switch _sender.tag {
        case buttonName.startDate.rawValue:
            segueToDatePickerView(buttonName: "planCheckDate")
            break;
            
        case buttonName.endDate.rawValue:
            segueToDatePickerView(buttonName: "planEndDate")
            break;
            
        default:
            break;
        }
        
        
    }
    
    
    // MARK: - メソッド
    
    
    func segueToDatePickerView(buttonName: String!){
      
        // 灰色のビューをつける
        opacityBackground.isHidden = false
        
        //遷移先画面の作成
        let storyBoard = UIStoryboard(name: "DatePickerView", bundle: nil)
        let popupVC    = storyBoard.instantiateViewController(withIdentifier: "DatePickerViewController") as? DatePickerViewController
        
        popupVC!.modalPresentationStyle = .overFullScreen
        popupVC!.modalTransitionStyle   = .coverVertical      // 下から出てくる
        
        // ボタンの種類を判定
        popupVC!.segueButtonName = buttonName
        
        // 遷移
        present(popupVC!, animated: true, completion: nil)
    }
    
    
    // Done可能か判定
    func doneOKStatus(){
        
        doneOk = true
        
        // 空欄があるならfalse
        if (planNameTf.text       == ""
            || planContentTf.text == ""
            || planCheckDate      == nil
            || planEndDate        == nil){
            doneOk = false
            doneButton.isEnabled       = doneOk
            planDecideButton.isEnabled = doneOk
            return
        }
        
        // checkDateはendDateより遅くあれ
        if(planCheckDate > planEndDate){
            doneOk = false
        }
        
        doneButton.isEnabled       = doneOk
        planDecideButton.isEnabled = doneOk
    }
    
}



// MARK: - UITextField関連
extension addPlanViewController:UITextFieldDelegate{
    
    // returnキー入力時の操作
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // doneチェック
        doneOKStatus()
        return true
    }
    
}



// MARK: - TableView関連
extension addPlanViewController:UITableViewDelegate, UITableViewDataSource{

    
    //  セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableContents.tableContentNum.rawValue
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let narrow: CGFloat = 140
        let normal: CGFloat = 150
        let wide:   CGFloat = 170
        
        switch indexPath.row {
        case tableContents.planName.rawValue:
            return narrow
        case tableContents.planContent.rawValue:
            return wide
        case tableContents.planComment.rawValue:
            return wide
        case tableContents.planCheckDate.rawValue:
            return normal
        case tableContents.planEndDate.rawValue:
            return normal
        case tableContents.planDecideButton.rawValue:
            return wide
        default:
            return 0
        }
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "addPlanTable")
        
        let widthSize = UIScreen.main.bounds.size.width
        
        
        // プラン名のとき
        if(indexPath.row == tableContents.planName.rawValue){
            
            let label = UILabel.init(frame: CGRect.init(x: 40, y: 30, width: 70, height: 40))
            label.text      = "プラン名"
            label.textColor = UIColor.black
            
            planNameTf = UITextField.init(frame: CGRect.init(x: 40, y: 70, width: widthSize - 80, height: 40))
         
            planNameTf.borderStyle  = .roundedRect
            planNameTf.keyboardType = .namePhonePad
            planNameTf.delegate     = self
            
            cell.addSubview(label)
            cell.addSubview(planNameTf)
        
            
        // プラン内容の時
        }else if(indexPath.row == tableContents.planContent.rawValue){
            
            let contentLabel = UILabel.init(frame: CGRect.init(x: 40, y: 20, width: widthSize / 2, height: 20))
            
            contentLabel.text      = "内容"
            contentLabel.textColor = UIColor.black
            
            planContentTf = UITextField.init(frame: CGRect.init(x: 40, y: 50, width: widthSize - 80, height: 80))

            planContentTf.borderStyle    = .roundedRect
            planContentTf.keyboardType   = .namePhonePad
            planContentTf.delegate       = self
            
            cell.addSubview(contentLabel)
            cell.addSubview(planContentTf)
            
            
        // コメントのとき
        }else if(indexPath.row == tableContents.planComment.rawValue){
             
             let contentLabel = UILabel.init(frame: CGRect.init(x: 40, y: 20, width: widthSize / 2, height: 20))
             
             contentLabel.text      = "コメント"
             contentLabel.textColor = UIColor.black
             
             planCommentTf = UITextField.init(frame: CGRect.init(x: 40, y: 50, width: widthSize - 80, height: 80))
           
             planCommentTf.borderStyle    = .roundedRect
             planCommentTf.keyboardType   = .namePhonePad
             planCommentTf.delegate       = self
             
             cell.addSubview(contentLabel)
             cell.addSubview(planCommentTf)
            
            
        // 確認日の設定
        }else if(indexPath.row == tableContents.planCheckDate.rawValue){
            
            let checkDateLabel = UILabel.init(frame: CGRect.init(x: 40, y: 20, width: widthSize / 2, height: 20))
            
            checkDateLabel.text      = "確認日の設定"
            checkDateLabel.textColor = UIColor.black
            
            planCheckDateButton = UIButton.init(frame: CGRect.init(x: 40, y: 60, width: widthSize * 3 / 4, height: 40))
            planCheckDateButton.setTitle("日付を選択", for: .normal)
            planCheckDateButton.backgroundColor       = UIColor.lightGray
            planCheckDateButton.tintColor = UIColor.black
            planCheckDateButton.addTarget(self, action: #selector(tapSelectDate(_sender:)), for: UIControl.Event.touchUpInside)
            planCheckDateButton.tag = buttonName.startDate.rawValue
            
            cell.addSubview(checkDateLabel)
            cell.addSubview(planCheckDateButton)
            
        
            
        // 終了日を設定
        }else if(indexPath.row == tableContents.planEndDate.rawValue){
            
            let checkDateLabel = UILabel.init(frame: CGRect.init(x: 40, y: 20, width: widthSize / 2, height: 20))
            
            checkDateLabel.text      = "終了日の設定"
            checkDateLabel.textColor = UIColor.black
            
            planEndDateButton = UIButton.init(frame: CGRect.init(x: 40, y: 60, width: widthSize * 3 / 4, height: 40))
            planEndDateButton.setTitle("日付を選択", for: .normal)
            planEndDateButton.addTarget(self, action: #selector(tapSelectDate(_sender:)), for: UIControl.Event.touchUpInside)
            planEndDateButton.backgroundColor       = UIColor.lightGray
            planEndDateButton.tintColor = UIColor.black
            
            planEndDateButton.tag = buttonName.endDate.rawValue
            
            cell.addSubview(checkDateLabel)
            cell.addSubview(planEndDateButton)
        
            
        // 決定ボタンの時
        }else if(indexPath.row == tableContents.planDecideButton.rawValue){
            
            planDecideButton = UIButton.init(frame: CGRect.init(x: 40, y: 60, width: widthSize * 3 / 4, height: 40))
            planDecideButton.setTitle("決定", for: .normal)
            planDecideButton.backgroundColor = UIColor.lightGray
            
            planDecideButton.addTarget(self, action: #selector(addPlanViewController.tapDoneButton), for: .touchUpInside)
            
            planDecideButton.isEnabled = false
            
            cell.addSubview(planDecideButton)
            
        }
        
        return cell
    }

}
