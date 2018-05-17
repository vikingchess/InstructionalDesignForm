//
//  IDImageView.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/17/18.
//  Copyright © 2018 David Flom. All rights reserved.
//

import UIKit

class IDImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 6.0
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     */
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}
