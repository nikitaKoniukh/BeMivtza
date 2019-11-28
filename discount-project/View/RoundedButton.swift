//
//  RoundedButton.swift
//  discount-project
//
//  Created by Nikita Koniukh on 01/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit


class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 3.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = cornerRadius
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
}
