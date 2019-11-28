//
//  RoundedView.swift
//  discount-project
//
//  Created by Nikita Koniukh on 13/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

extension UIVisualEffectView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
}
