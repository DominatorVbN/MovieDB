//
//  TMDBAPI.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import Foundation
import ElegantAPI


enum TMDBAPI {
    case trending
    case popular
}

// Provider and Keys
extension TMDBAPI {
    static let provider = TMDBApiProvider()
    private static let apiKey = "38a73d59546aa378980a88b645f487fc"
}

extension TMDBAPI: API {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .popular:
            return "popular"
        case .trending:
            return "trending/all/day"
        }
    }
    
    var method: ElegantAPI.Method {
        switch self {
        case .trending, .popular:
            return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case .trending:
            return .requestParameters(
                parameters: ["api_key": TMDBAPI.apiKey],
                encoding: .URLEncoded
            )
        case .popular:
            return .requestParameters(
                parameters: [
                    "api_key": TMDBAPI.apiKey,
                    "language": "en-US",
                    "page": 1
                ],
                encoding: .URLEncoded
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .trending, .popular:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        }
    }
}
