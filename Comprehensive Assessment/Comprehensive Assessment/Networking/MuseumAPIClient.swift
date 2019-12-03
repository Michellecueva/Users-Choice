//
//  MuseumAPIClient.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

struct MuseumAPIClient {
    
    static let manager = MuseumAPIClient()
    
    private func  getMuseumURL(maker: String) -> URL {
        guard let url = URL(string: "https://www.rijksmuseum.nl/api/en/collection?key=\(Secrets.museumAPIKey)&involvedMaker=\(maker)") else {fatalError("Error: Invalid URL")}
     return url
}
    

    func getTickets(maker: String, completionHandler: @escaping (Result<([ArtObject]), AppError>) -> Void) {
        NetworkHelper.manager.performDataTask(withUrl: getMuseumURL(maker: maker), andMethod: .get) { result in
            switch result {
            case let .failure(error):
                completionHandler(.failure(error))
                return
            case let .success(data):
                do {
                    let artObject = try MuseumWrapper.decodeObjectFromData(from: data)
                    completionHandler(.success(artObject))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
    

    private init() {}
}
