//
//  customButtonSwap.swift
//  ZatuPhotography
//
//  Created by khoirunnisa' rizky noor fatimah on 31/05/19.
//  Copyright © 2019 khoirunnisa' rizky noor fatimah. All rights reserved.
//

import UIKit

class customButtonSwap: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("Swap", for: .normal)
        self.setTitleColor(UIColor.blue, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
