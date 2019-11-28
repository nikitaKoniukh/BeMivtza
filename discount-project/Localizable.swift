//
//  Localizable.swift
//  discount-project
//
//  Created by Nikita Koniukh on 23/07/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation

enum LocalizableEnum {

    enum Global: String, LocalizableDelegate {
        case cancel, close
    }

    enum HomeScreen: String, LocalizableDelegate {
        case noInternetConnection = "Sorry, no Internet connection"

    }

    enum InApp: String, LocalizableDelegate {
        case title = "inAppTitle"
        case subtitle = "inAppSubtitle"
        case description = "inAppDescription"


        var table: String? {
            return "InApps"
        }
    }
}
