////
////  RatingView.swift
////  lec25
////
////  Created by Nikita Koniukh on 31/05/2019.
////  Copyright © 2019 Nikita Koniukh. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//@IBDesignable class RatingView: UIView {
//    
//    @IBOutlet weak var starStack: UIStackView?
//    
//
//    var contentView: UIView?
//    
//    @IBInspectable
//    var rating: Int = 3{
//        didSet{
//            renderRating()
//        }
//    }
//    
//  
//    
//    func renderRating(){
//        
//        if rating > 5 || rating <= 0 {
//            return
//        }
//        
//        let bundle = Bundle(for: RatingView.self)
//        let starFull = UIImage(named: "star_filled",
//                            in: bundle,
//                            compatibleWith: self.traitCollection)
//        
//        let star = UIImage(named: "star",
//                               in: bundle,
//                               compatibleWith: self.traitCollection)
//        
//        guard let buttons = starStack?.arrangedSubviews as? [UIButton] else {return}
//        
//        //first - reset all stars to empty
//        buttons.forEach{
//            $0.setImage(star, for: .normal)
//        }
//        
//        for i in 0..<rating{
//            buttons[i].setImage(starFull, for: .normal)
//            
//        }
//    }
//
//    
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        commonInit()
//        renderRating()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        renderRating()
//        
//        guard let buttons = starStack?.arrangedSubviews as? [UIButton] else {return}
//        
//        
//        for (index, btn) in buttons.enumerated(){
//            btn.addTarget(self, action: #selector(ratingChanged(_:)), for: .touchUpInside)
//            btn.tag = index + 1
//            
//        }
//    }
//    
//    @objc func ratingChanged(_ sender: UIButton){
//        self.rating = sender.tag
//    }
//    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        commonInit()
//        renderRating()
//    }
//    
//  
//    
//    func commonInit(){
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: "RatingView", bundle: bundle)
//        
//        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
//        contentView?.frame = self.frame
//        contentView?.translatesAutoresizingMaskIntoConstraints = false
//        
//        guard let cv = contentView else {return}
//        
//        addSubview(cv)
//        
//        NSLayoutConstraint.activate([
//            cv.leftAnchor.constraint(equalTo: leftAnchor),
//            cv.rightAnchor.constraint(equalTo: rightAnchor),
//            cv.topAnchor.constraint(equalTo: topAnchor),
//            cv.bottomAnchor.constraint(equalTo: bottomAnchor)
//            ])
//    }
//
//}
