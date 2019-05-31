//
//  customLabel.swift
//  ZatuPhotography
//
//  Created by khoirunnisa' rizky noor fatimah on 31/05/19.
//  Copyright © 2019 khoirunnisa' rizky noor fatimah. All rights reserved.
//

import UIKit

class customLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    

}
