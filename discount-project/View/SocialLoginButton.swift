//
//  SocialLoginButton.swift
//  discount-project
//
//  Created by Nikita Koniukh on 07/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class SocialLoginButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 3.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.layer.borderWidth = 0.5
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
