//
//  HomeViewController.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/31.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // タブボタンの判定
    enum openView: Int{
        case planList = 0
        case setting  = 1
    }
    
    // Viewパーツ
    @IBOutlet weak var homeTab:        UITabBar!
    @IBOutlet weak var homeNavi:       UINavigationItem!
    @IBOutlet weak var addPlanButton:  UIButton!
    
    
    // 変数(このビュー)
    private var planTableView:  UITableView!
    private var suggestView:    UIView!
    private var openViewTag:    Int!
    
    // ViewModel
    let planViewModel = PlanViewModel.init()
    
    // リスト
    var planList:       Array<Plan>!
    
    
    // メイン
    override func viewDidLoad() {
        
        getLog.getLog(message: "viewDidLoad")
        
        /** ナビゲーションバー設定 **/
        homeNavi.title = "プラン一覧"
        addPlanButton.addTarget(self, action: #selector(HomeViewController.tappedAddButton), for: .touchUpInside)
        
        
        // usefulSize取得
        let usefulSize = getSize.usefulSize(UIView: self)
        

        // タブの高さを取得
        let tabHeight = self.homeTab.frame.size.height
        
        
        // タブのサイズを編集(iPhoneX以上用)
        self.homeTab.frame = getSize.tabHeight(tabHeight: tabHeight)
        
        
        // Viewのサイズを取得
        let size = getSize.getScreenSizeWithTab(naviHeight: usefulSize["naviHeight"]!, tabHeight: tabHeight)
        
        
        // 全プランを取得
        planList = planViewModel.readPlan(type:"all", word: nil, compare: nil)
        
        
        // プランがあるならテーブルビューを生成
        if(planList != nil && planList.count > 0){
            
            planTableView                 = UITableView.init(frame: size)
            planTableView.separatorStyle  = .none
            planTableView.delegate        = self
            planTableView.dataSource      = self
            planTableView.tag             = openView.planList.rawValue
            
            self.view.addSubview(self.planTableView)
            
        // プランがないならsuggestViewを作成
        }else{
            
            self.suggestView   = UIView.init(frame: size)
            self.suggestView.backgroundColor = UIColor.lightGray
            self.view.addSubview(self.suggestView)
        }
        
        
        // 初期ViewはプランView
        openViewTag = openView.planList.rawValue
        
        // 設定画面作成、隠す
        let settingView        = UITableView.init(frame: size)
        settingView.delegate   = self
        settingView.dataSource = self
        settingView.tag        = openView.setting.rawValue
        settingView.isHidden   = true
        self.view.addSubview(settingView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getLog.getLog(message: "viewWillAppear")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Outlet action
    
    
    
    // addPlanButtonタップ時
    @objc private func tappedAddButton(_ sender: UIButton){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "addPlanViewController")
        
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - HomeViewController method
    
    
}


// MARK: - TableView関連

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
      // セル個数
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
          if(planList != nil && planList.count > 0){
              return planList.count
              
          }else{
              return 0
          }
      }
      
      
      // セルの高さ
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
          switch(tableView.tag){
              
           case openView.planList.rawValue:
               return 200
              
           case openView.setting.rawValue:
               return 0
              
           default:
               return 0
          }
          
      }
      
      
      // セル設定
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          // プラン一覧の時
          if(tableView.tag == openView.planList.rawValue){
              // planを取り出す
              let plan = planList[indexPath.row]
              
              // cellの生成
              let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewController", for: indexPath)
              
              let screenWidth  = UIScreen.main.bounds.size.width
              let screenHeight = UIScreen.main.bounds.size.height
            
              
              // planの生成
              let view = HomeViewCell.init(frame: CGRect.init(x: 10, y: 10, width: screenWidth - 20, height: 80))
              
              // planViewの設定
              view.layer.cornerRadius = 3
              view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
              view.layer.shadowColor = UIColor.black.cgColor
              view.layer.shadowOpacity = 0.6
              view.layer.shadowRadius = 3
            
              // view内要素の大きさ設定
            view.planTitle.frame = CGRect.init(x: 10, y: 10, width: view.frame.width * 3 / 4, height: 21)
            
            view.planComment.frame = CGRect.init(x: 10, y: 41, width: view.frame.width - 20, height: 42)
            
            view.planEndDateView.frame = CGRect.init(x: screenWidth - 215, y: screenHeight - 31, width: 205, height: 21)
              
              // planの要素を書き出す
              view.planTitle?.text   = plan.planName
              view.planComment.text  = plan.planComment
              view.planEndDate?.text = dateFormat.dateToStringDayOnly(date: plan.planEndDate)
              
              cell.addSubview(view)
              
              return cell
              
          // 設定画面の時
          }else if(tableView.tag == openView.setting.rawValue){
              let cell = UITableViewCell.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
              
              return cell
              
          }else{
              let cell = UITableViewCell.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
              
              return cell
          }
    
      }
      
      

      // セルタップ時
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
      }

}
