//
//  ProductModel.swift
//  discount-project
//
//  Created by Nikita Koniukh on 16/07/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation
import CoreLocation


struct ProductModel {

    private(set) var name: String!
    private(set) var numLikes: Int!
    private(set) var price: Double!
    private(set) var storeLocation: CLLocation!
    private(set) var timeStamp: Date!
    private(set) var documentId: String!
    private(set) var imageUrl: String?
    //var ratingButtonPressed: Bool!
    private(set) var longitude: Double!
    private(set) var latitude: Double!
    private(set) var storeName: String!
    private(set) var storeAddress: String!
    private(set) var disLikeCounter: Int!
    private(set) var userName: String!
}
