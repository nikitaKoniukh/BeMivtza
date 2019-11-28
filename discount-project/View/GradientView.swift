//
//  GradientView.swift
//  discount-project
//
//  Created by Nikita Koniukh on 14/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

import UIKit

@IBDesignable // to see changes in storyboard live
class GradientView: UIView {
    
    //update layout of the view dinamicly
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    //called when layout of the view is updated
    override func layoutSubviews() {
        
        //creating gradiend
        let gradientLayer = CAGradientLayer()
        
        //1. colors
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        
        //2. position
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        //3. size
        gradientLayer.frame = self.bounds //size of the layout
        
        //add gradient layer to UIViewLayers
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
