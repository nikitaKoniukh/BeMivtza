//
//  Constains.swift
//  discount-project
//
//  Created by Nikita Koniukh on 01/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

typealias CompletionHandler = (_ Success: Bool) ->()

enum ProductCategory : String {
    case popular = "פופולרי"
    case food = "אוכל"
    case clothing = "ביגוד"
    case cosmetics = "קוסמטיקה"
    case electronics = "אלקטרוניקה"
}

//
let PRODUCT_LIST_REF = "productsList"
let USERS_REF = "users"

let CATEGORY_NAME  = "category"
let NUM_LIKES = "numLikes"
let DIS_LIKE_COUNTER = "disLikeCounter"
let PRODUCT_NAME = "name"
let TIME_STAMP = "timeStamp"
let PRODUCT_PRICE = "price"
let STORE_LOCATION = "storeLocation"
let USERNAME = "username"
let IS_ADMIN = "isAdmin"
let DATE_CREATED = "dateCreated"
let PRODUCT_IMAGE_URL = "productImageUrl"

let USER_ID = "userId"
let IS_RATE_PRODUCT = "isRateProduct"

let STORE_NAME = "storeName"
let STORE_ADDRESS = "storeAddress"
