//
//  Museum.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

struct MuseumWrapper: Codable {
    let artObjects: [ArtObject]
    
    static func decodeObjectFromData(from jsonData: Data) throws -> ([ArtObject]) {
              let response = try JSONDecoder().decode(MuseumWrapper.self, from: jsonData)
        return (response.artObjects)
          }
}

struct ArtObject: Codable, RequiredFields {
  
    
    private let objectNumber: String
    private let title: String
    private let principalOrFirstMaker: String
    private let webImage: WebImage
    
    var imageUrl: String {
        return webImage.url
    }
      
    var heading: String {
        return title
    }
      
    var subheading: String {
        return principalOrFirstMaker
    }
      
    var price: String?
      
    var linkToEvent: String?
    
    var objectID: String? {
        return objectNumber
    }
    
      var favoriteID: String?
    
}

struct WebImage: Codable {
    let url: String
}
