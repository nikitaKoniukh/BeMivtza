//
//  DateFormater.swift
//  discount-project
//
//  Created by Nikita Koniukh on 04/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import Firebase

class FormateDateInstance {
    
    static let instance = FormateDateInstance()
    
    func formateDate(timeStamp: Date)-> String{
        let formater = DateFormatter()
        formater.dateFormat = "MMM d, hh:mm"
        let timestamp = formater.string(from: timeStamp)
        return timestamp
    }
    
}
