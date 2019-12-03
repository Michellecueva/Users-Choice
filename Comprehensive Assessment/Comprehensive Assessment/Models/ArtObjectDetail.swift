//
//  ArtObjectDetail.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/3/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

struct ArtObjectWrapper: Codable {
    let artObject: ArtObjectDetail
    
    static func decodeDetailsFromData(from jsonData: Data) throws -> ArtObjectDetail {
                 let response = try JSONDecoder().decode(ArtObjectWrapper.self, from: jsonData)
        return (response.artObject)
    }
}

struct ArtObjectDetail: Codable {
    let plaqueDescriptionEnglish: String?
    let productionPlaces: [String]
    let dating: Dating
}

struct Dating: Codable {
    let presentingDate: String
}
