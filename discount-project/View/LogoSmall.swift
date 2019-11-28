//
//  LogoSmall.swift
//  discount-project
//
//  Created by Nikita Koniukh on 15/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class LogoSmall: UIImageView {
    
    static let instance = LogoSmall()
    
    func setLogo()-> UIImageView{
        let image: UIImage = UIImage(named: "BeMivtzaLogoNew")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        return imageView
    }
    
}
