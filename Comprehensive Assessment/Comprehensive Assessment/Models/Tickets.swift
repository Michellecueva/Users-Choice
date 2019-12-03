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
}

struct EmbeddedWrapper: Codable {
    let events: [Event]
}

struct Event: Codable {
    let name: String?
    let url: String?
    let images: [Image]?
    let dates: Date?
    let priceRanges: [PriceRange]?
}

struct Image: Codable {
    let url: String
}

struct Date: Codable {
    let start: Start
}

struct Start: Codable {
    let localDate: String
    let localTime: String
    let dateTime: String
}

struct PriceRange: Codable {
    let min: Int
    let max: Int
}
