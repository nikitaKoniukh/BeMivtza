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
    
    func formateDate(timeStamp: Date) -> String{
        let timestamp = DateFormatter.displayedDateFormatter.string(from: timeStamp)
        return timestamp
    }
    
}

extension Date {
    var timestamp: String {
        return DateFormatter.displayedDateFormatter.string(from: self)
    }
}

extension DateFormatter {
    static let displayedDateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "MM.dd.yyyy"
        return formater
    }()
}
