//
//  Product.swift
//  discount-project
//
//  Created by Nikita Koniukh on 02/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Contacts
import CoreLocation

class ProductsService{
     func parseData(snapshot: QuerySnapshot?)-> [ProductModel]{

        var products = [ProductModel]()
        
        guard let snap = snapshot else {return products}
        for document in snap.documents{
            let data = document.data()
            
            let name = data[PRODUCT_NAME] as? String ?? "no name"
            let timeStampGoogle = data[TIME_STAMP] as? Timestamp ?? Timestamp()
            let timeStamp =  timeStampGoogle.dateValue()
            
            let numLikes = data[NUM_LIKES] as? Int ?? 0
            
            let disLikeCounter = data[DIS_LIKE_COUNTER] as? Int ?? 0
            
            let price = data[PRODUCT_PRICE] as? Double ?? 000
            let storeLocation = data[STORE_LOCATION] as? GeoPoint
            let latitude = storeLocation?.latitude ?? 21.283921
            let longitude = storeLocation?.longitude ?? -157.831661
            
            let myGeoPoint = CLLocation.init(latitude: latitude, longitude: longitude)
            
            let documentId = document.documentID
            let image = data[PRODUCT_IMAGE_URL] as? String ?? ""
            let storeAddress = data[STORE_ADDRESS] as? String ?? ""
            let storeName = data[STORE_NAME] as? String ?? ""
            let userName = data[USERNAME] as? String ?? ""

            let newProduct = ProductModel(name: name, numLikes: numLikes, price: price, storeLocation: myGeoPoint, timeStamp: timeStamp, documentId: documentId, imageUrl: image, longitude: longitude, latitude:latitude, storeName: storeName, storeAddress: storeAddress, disLikeCounter: disLikeCounter, userName: userName)
            products.append(newProduct)
        }
        return products
    }
}
