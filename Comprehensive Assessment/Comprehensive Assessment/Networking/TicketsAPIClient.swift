//
//  TicketsAPIClient.swift
//  Comprehensive Assessment
//
//  Created by Michelle Cueva on 12/2/19.
//  Copyright © 2019 Michelle Cueva. All rights reserved.
//

//import Foundation
//
//
//struct TicketsAPIClient {
//    
//    
//    static let manager = TicketsAPIClient()
//    
//
//    
//    private func  getWeatherURL(lat: Double, long: Double) -> URL {
//        guard let url = URL(string: "https://api.darksky.net/forecast/\(Secrets.DarkSkyAPIKey)/\(lat),\(long)") else {fatalError("Error: Invalid URL")}
//     return url
//}
//    
//
//    func getWeather(lat: Double, long: Double, completionHandler: @escaping (Result<([Weather], String), AppError>) -> Void) {
//        NetworkHelper.manager.performDataTask(withUrl: getWeatherURL(lat: lat, long: long), andMethod: .get) { result in
//            switch result {
//            case let .failure(error):
//                completionHandler(.failure(error))
//                return
//            case let .success(data):
//                do {
//                    let weather = try WeatherWrapper.decodeWeatherFromData(from: data)
//                    completionHandler(.success(weather))
//                }
//                catch {
//                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
//                }
//            }
//        }
//    }
//    
//
//    private init() {}
//}
