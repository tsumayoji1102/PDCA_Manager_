//
//  homeViewCell.swift
//  PDCA-manager
//
//  Created by 塩見陵介 on 2019/10/31.
//  Copyright © 2019 塩見陵介. All rights reserved.
//

import UIKit

class HomeViewCell: UIView {

    @IBOutlet weak var planTitle:      UILabel!
    @IBOutlet weak var planComment:    UILabel!
    @IBOutlet weak var planEndDate:    UILabel!
    @IBOutlet weak var planEndDateView: UIView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performanceduring animation.
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("homeViewCell", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
     
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
