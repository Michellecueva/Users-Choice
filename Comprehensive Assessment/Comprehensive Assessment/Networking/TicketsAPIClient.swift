//
//  TicketsAPIClient.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation


struct TicketsAPIClient {
    
    
    static let manager = TicketsAPIClient()
    

    
    private func  getTicketsURL(city:String, state: String) -> URL {
        let fixedStr = city.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/events.json?apikey=\(Secrets.ticketAPIKey)&city=\(fixedStr)&stateCode=\(state)") else {fatalError("Error: Invalid URL")}
     return url
}
    

    func getTickets(city: String, state: String, completionHandler: @escaping (Result<([Event]), AppError>) -> Void) {
        NetworkHelper.manager.performDataTask(withUrl: getTicketsURL(city: city, state: state), andMethod: .get) { result in
            switch result {
            case let .failure(error):
                completionHandler(.failure(error))
                return
            case let .success(data):
                do {
                    let event = try TicketWrapper.decodeEventFromData(from: data)
                    completionHandler(.success(event))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
    

    private init() {}
}
