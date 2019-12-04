//
//  FieldsProtocol.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/3/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

protocol RequiredFields {
    var imageUrl: String {get}
    var heading: String {get }
    var subheading: String {get }
    
    var price: String? {get}
    var linkToEvent: String? {get }
    
    var objectID: String? {get}
}
