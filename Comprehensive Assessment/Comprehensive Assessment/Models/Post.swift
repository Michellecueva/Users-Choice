//
//  Post.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/4/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Post: RequiredFields {
    
    let title: String
    let imageURL: String
    let subtitle: String
    let id: String
    let dateCreated: Date?
    
    init(title: String, imageURL: String, subtitle: String, dateCreated: Date? = nil) {
        self.title = title
        self.imageURL = imageURL
        self.subtitle = subtitle
        self.id = UUID().description
        self.dateCreated = dateCreated
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let imageUrl = dict["imageUrl"] as? String,
            let title = dict["title"] as? String,
            let subtitle = dict["subtitle"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
        
        self.imageURL = imageUrl
        self.title = title
        self.subtitle = subtitle
        self.id = id
        self.dateCreated = dateCreated
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
    
    var postID: String? {
        return id
    }
    
    var price: String?
    
    var linkToEvent: String?
    
    var objectID: String?
    
    var fieldsDict: [String: Any] {
        return [
            "imageUrl": self.imageURL,
            "title": self.title,
            "subtitle": self.subtitle,
        ]
    }
}

