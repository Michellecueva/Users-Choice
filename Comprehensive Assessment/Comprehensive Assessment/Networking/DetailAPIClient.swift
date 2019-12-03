//
//  DetailAPIClient.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/3/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

import Foundation

struct DetailAPIClient {
    
    static let manager = DetailAPIClient()
    
    private func  getDetailURL(objectNumber: String) -> URL {
        guard let url = URL(string: "https://www.rijksmuseum.nl/api/en/collection/\(objectNumber)?key=\(Secrets.museumAPIKey)") else {fatalError("Error: Invalid URL")}
     return url
}
    

    func getDetailObjects(objectNumber: String, completionHandler: @escaping (Result<ArtObjectDetail, AppError>) -> Void) {
        NetworkHelper.manager.performDataTask(withUrl: getDetailURL(objectNumber: objectNumber), andMethod: .get) { result in
            switch result {
            case let .failure(error):
                completionHandler(.failure(error))
                return
            case let .success(data):
                do {
                    let artObjectDetail = try ArtObjectWrapper.decodeDetailsFromData(from: data)
                    completionHandler(.success(artObjectDetail))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
    

    private init() {}
}
