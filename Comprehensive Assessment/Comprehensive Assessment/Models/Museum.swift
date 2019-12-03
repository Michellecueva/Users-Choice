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
}

struct ArtObject: Codable {
    let objectNumber: String
    let title: String
    let principalOrFirstMaker: String
    let webImage: WebImage
    
}

struct WebImage: Codable {
    let url: String
}
