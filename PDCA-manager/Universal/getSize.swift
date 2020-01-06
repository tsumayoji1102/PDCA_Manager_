//
//  getScreenSize.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/11/01.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit

class getSize {
    
    // 画面サイズ取得(tabBarなし)
    static func getScreenSize(naviHeight: CGFloat) ->CGRect{
        
        // sizeを設定
        let screenSize    = UIScreen.main.bounds.size
        let screenWidth   = screenSize.width
        let screenHeight  = screenSize.height
        
        // ステータスバーの高さを取得する
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        // Viewの高さを変更
        let viewHeight = screenHeight - naviHeight - statusBarHeight * 2
        
        // Viewのサイズを取得
        let size = CGRect.init(x: 0, y: naviHeight + statusBarHeight, width: screenWidth, height: viewHeight)
        
        return size
    }
    
    
    
    // 画面サイズ取得（tabBarあり）
    static func getScreenSizeWithTab(naviHeight: CGFloat, tabHeight: CGFloat) -> CGRect{
        
        // sizeを設定
        let screenSize    = UIScreen.main.bounds.size
        let screenWidth   = screenSize.width
        let screenHeight  = screenSize.height
        
        
        // ステータスバーの高さを取得する
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        // インジケータの高さを取得する
        let indicatorHeight = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
    
        
        // Viewの高さを変更
        let viewHeight = screenHeight - naviHeight - tabHeight - statusBarHeight - indicatorHeight
        
        // Viewのサイズを取得
        let size = CGRect.init(x: 0, y: naviHeight + statusBarHeight, width: screenWidth, height: viewHeight)
        
        return size
    }
    
    
    
    // タブのサイズを取得
    static func tabHeight(tabHeight: CGFloat) -> CGRect{
        
        // sizeを設定
        let screenSize    = UIScreen.main.bounds.size
        let screenHeight  = screenSize.height
        
        let y = screenHeight - usefulSize(UIView: nil)["indicatorHeight"]! - tabHeight
        
        let newTabHeight = usefulSize(UIView: nil)["indicatorHeight"]! + tabHeight
        
        let size = CGRect.init(x: 0, y: y, width: screenSize.width, height: newTabHeight)
        
        return size
    }
    
    
    
    
    // ステータスバー,インジケータ、ナビゲーションバーの高さを取得
    static func usefulSize(UIView: UIViewController?) ->Dictionary<String, CGFloat>{
        
        var dic = Dictionary<String, CGFloat>()
        
        // ステータスバーの高さを取得する
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        // インジケーターの高さを取得する
        let indicatorHeight =
            UIApplication.shared.keyWindow!.safeAreaInsets.bottom
        
        // ナビゲーションバーの高さを取得する
        let naviHeight = UIView?.navigationController?.navigationBar.frame.size.height
            
        dic["statusBarHeight"] = statusBarHeight
        dic["indicatorHeight"] = indicatorHeight
        dic["naviHeight"]      = naviHeight
        
        return dic
    }

}
