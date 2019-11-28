//
//  LocallizableEnum.swift
//  discount-project
//
//  Created by Nikita Koniukh on 23/07/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation

enum LocalizableEnum {

    enum Global: String, LocalizableDelegate {
        case ok = "OK"
        case oops = "Oops!"
        case yesOfCourse = "Yes, of course!"
        case no = "No"
        case thanks = "Thank you"
        case cancel = "Cancel"
    }

    enum HomeScreen: String, LocalizableDelegate {
        case noInternetConnection = "Sorry, no Internet connection"
        case noPermissionToDellete = "You have no permissions to delete items"
        case headerText = "There are no offers in this category"
        case backBtn = "Back"
    }

    enum AddDiscount: String, LocalizableDelegate {
        case pressCameraBtn = "Press the camera button to select the picture"
        case takePictureAlert = "Take a picture"
        case selectPhotoAlert = "Select a photo"

        case confidence = "Confidence"
    }

    enum finishAddingProduct: String, LocalizableDelegate {
        case noZeroPrice = "The price can not be zero"
        case noEmptyFields = "All fields must be filled"
    }

    enum Map: String,LocalizableDelegate {
        case alertTitle = "Do you want to provide access to your geographic location?"
        case alertMessage = "We want to show you the hottest offers near you!"
        case storeAddress = "store address"
    }

    enum SwipeDetail: String, LocalizableDelegate {
        case alreadySendFeedback = "You have already submitted feedback"
        case smthWrongAlertTitle = "Something wrong with this post?"
        case sendEmailAlertMessage = "Please let us know by sending an email:"
        case noRelevantAlready = "Not relevant already"
        case postNotValid = "Post or image is not valid"
        case thanksForFeedbackAlertTitle = "Thanks for your feedback"
        case enjoyAppAlertMessage = "We're doing everything we can to enjoy our app!"
    }

    enum AppIntro: String, LocalizableDelegate {
        case firstPageTitle = "Welcome to the social network of discounts and offers!"
        case firstPageDescription = "This is an easy way to share the best deals in your area"
        case secondPageTitle = "You can find different products in the list or on the map"

        case thirdPageTitle = "Rating Discounts"
        case thirdPageDescription = "You say this assumption is relevant or not"

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

