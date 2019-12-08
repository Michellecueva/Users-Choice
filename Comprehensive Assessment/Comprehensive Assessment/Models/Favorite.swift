//
//  Favorite.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/4/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Favorite: RequiredFields {
    let title: String
    let imageURL: String
    let subtitle: String
    let id: String
    let dateCreated: Date?
    let creatorID: String
    let itemID: String
    let accountType: String
    
    init(title: String, imageURL: String, subtitle: String, dateCreated: Date? = nil, creatorID: String, itemID: String, accountType: String) {
        self.title = title
        self.imageURL = imageURL
        self.subtitle = subtitle
        self.id = UUID().description
        self.dateCreated = dateCreated
        self.creatorID = creatorID
        self.itemID = itemID
        self.accountType = accountType
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let imageUrl = dict["imageUrl"] as? String,
            let title = dict["title"] as? String,
            let subtitle = dict["subtitle"] as? String,
            let userID = dict["creatorID"] as? String,
            let itemID = dict["itemID"] as? String,
            let accountType = dict["accountType"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
           
        
        self.imageURL = imageUrl
        self.title = title
        self.subtitle = subtitle
        self.id = id
        self.dateCreated = dateCreated
        self.creatorID = userID
        self.itemID = itemID
        self.accountType = accountType
    }
    
    var imageUrl: String {
        return imageURL
    }
    
    var heading: String {
        return title
    }
    
    var subheading: String {
        return subtitle
    }
    
    var favoriteID: String? {
        return creatorID
    }
    
    var uniqueItemID: String {
        return itemID
    }
    
    var price: String?
    
    var linkToEvent: String?
    
    var objectID: String? 
    
    var fieldsDict: [String: Any] {
        return [
            "imageUrl": self.imageURL,
            "title": self.title,
            "subtitle": self.subtitle,
            "creatorID": self.creatorID,
            "itemID": self.itemID,
            "accountType": self.accountType,
        ]
    }
}
