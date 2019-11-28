//
//  CustomAlertView.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 09/04/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class CustomAlert: UIView, ModalDelegate {
    var backgroundView = UIView()
    var dialogView = UIView()
    
    
    
    
    convenience init(title:String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameTextField = UITextField()
    
    
    func initialize(title:String){
        dialogView.clipsToBounds = true
        
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-64
        
        
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 100))
        titleLabel.text = title
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = #colorLiteral(red: 0.9950143695, green: 0.6980803609, blue: 0.03776598722, alpha: 1)
        titleLabel.font =  UIFont(name: "Abraham", size: 25)
        dialogView.addSubview(titleLabel)
        
        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 0, y: titleLabel.frame.height + 8)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(separatorLineView)
        
        
//        nameTextField.frame.origin = CGPoint(x: 8, y: titleLabel.frame.height + 8 + separatorLineView.frame.height + 8)
//        nameTextField.frame.size = CGSize(width: dialogViewWidth - 16, height: 50)
//        nameTextField.backgroundColor = UIColor.groupTableViewBackground
//        nameTextField.becomeFirstResponder()
//        nameTextField.font =  UIFont(name: "Helvetica Neue", size: 25)
//        nameTextField.layer.cornerRadius = 4
//        dialogView.addSubview(nameTextField)
        
        
        let buttonOk = UIButton(type: .system)
        buttonOk.frame.origin = CGPoint(x: 8, y: titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + nameTextField.frame.height + 16)
        buttonOk.frame.size = CGSize(width: dialogViewWidth - 16, height: 50)
       
        buttonOk.setTitle("סבבה", for: .normal)
        buttonOk.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        buttonOk.titleLabel?.font =  UIFont(name: "Abraham", size: 25)
       
        
        buttonOk.backgroundColor = #colorLiteral(red: 0.9950143695, green: 0.6980803609, blue: 0.03776598722, alpha: 1)
        
        buttonOk.layer.cornerRadius = 4
        buttonOk.layer.shadowOpacity = 1
        buttonOk.layer.shadowRadius = 1
        buttonOk.layer.shadowColor = #colorLiteral(red: 0.7157995162, green: 0.7157995162, blue: 0.7157995162, alpha: 1).cgColor
        buttonOk.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        buttonOk.addTarget(self, action: #selector(pressedAction), for: .touchUpInside)
        dialogView.addSubview(buttonOk)
        
//        let buttonNo = UIButton(type: .system)
//        buttonNo.frame.origin = CGPoint(x: 8, y: titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + nameTextField.frame.height + 8 + buttonOk.frame.height + 20)
//        buttonNo.frame.size = CGSize(width: dialogViewWidth - 16, height: 50)
//
//        buttonNo.setTitle("בטל", for: .normal)
//        buttonNo.setTitleColor(#colorLiteral(red: 0.7853941942, green: 0.6720381421, blue: 0, alpha: 1), for: .normal)
//        buttonNo.titleLabel?.font =  UIFont(name: "Helvetica Neue", size: 25)
//
//
//        buttonNo.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
//        buttonNo.layer.cornerRadius = 4
//        buttonNo.layer.shadowOpacity = 1
//        buttonNo.layer.shadowRadius = 1
//        buttonNo.layer.shadowColor = #colorLiteral(red: 0.7157995162, green: 0.7157995162, blue: 0.7157995162, alpha: 1).cgColor
//        buttonNo.layer.shadowOffset = CGSize(width: 2, height: 2)
//
//        buttonNo.addTarget(self, action: #selector(didTappedOnBackgroundView), for: .touchUpInside)
//        dialogView.addSubview(buttonNo)

        
        let dialogViewHeight = titleLabel.frame.height + 8 + separatorLineView.frame.height + 8 + buttonOk.frame.height + 32
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height/2)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
        
    }
    
    @objc func pressedAction(){        
        dismiss(animated: true)
    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
   
    
}
