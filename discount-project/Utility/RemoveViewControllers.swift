//
//  RemoveViewControllers.swift
//  discount-project
//
//  Created by Nikita Koniukh on 06/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

class RemoveViewControllers{
    
    static let instance = RemoveViewControllers()
    
    func removeControllers(){
        
        let navigationController = UINavigationController()
        var navigationArray = navigationController.viewControllers //To get all UIViewController stack as Array
        navigationArray.removeAll() // To remove previous UIViewController
        navigationController.viewControllers = navigationArray
    }
    
}
