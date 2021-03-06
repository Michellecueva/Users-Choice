//
//  Tickets.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

struct TicketWrapper: Codable {
    let _embedded: EmbeddedWrapper
    
    static func decodeEventFromData(from jsonData: Data) throws -> ([Event]) {
        let response = try JSONDecoder().decode(TicketWrapper.self, from: jsonData)
        return (response._embedded.events)
    }
}

struct EmbeddedWrapper: Codable {
    let events: [Event]
}

struct Event: Codable, RequiredFields {
    
    let id: String
    let name: String
    let url: String?
    let images: [Image]
    let dates: DateOfEvent?
    let priceRanges: [PriceRange]?
    
    var imageUrl: String {
        return images[0].url
    }
    
    var heading: String {
        return name
    }
    
    var subheading: String {
        guard let dates = dates else {return "No date found"}
        
        let stringToFormat = dates.start.dateTime
        
        return stringToFormat.dateFormatForString

    }
    
    var price: String? {
        guard let price = priceRanges else {return "Price information not available"}
        return "$\(price[0].min) - $\(price[0].max)"
    }
    
    var linkToEvent: String? {
        return url
    }
    var uniqueItemID: String {
        return id
    }
    
    var objectID: String?
    var favoriteID: String?
    
}

struct Image: Codable {
    let url: String
}

struct DateOfEvent: Codable {
    let start: Start
}

struct Start: Codable {
    let dateTime: String
}

struct PriceRange: Codable {
    let min: Double
    let max: Double
}
