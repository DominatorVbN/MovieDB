//
//  PaginatedMovieResponse.swift
//  MovieDB
//
//  Created by Amit Samant on 30/10/21.
//

import Foundation

import Foundation
import UIKit
// MARK: - PaginatedMovieResponse
struct PaginatedMovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie
struct Movie: Decodable {

    let posterPath: String
    let title: String?
    let mediaType: String?
    let id: Int
    let imageURL: URL?
    let overview: String?
    let releaseDate: String?
    let rating: Double?
    let popularity: Double?

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case title = "title"
        case id = "id"
        case name = "name"
        case imageURL
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case overview
        case rating = "vote_average"
        case popularity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
        self.posterPath = posterPath
        self.title = try (container.decodeIfPresent(String.self, forKey: .title)) ?? ( container.decodeIfPresent(String.self, forKey: .name))
        let imageURLString = "https://image.tmdb.org/t/p/w200\(posterPath)"
        self.imageURL = URL(string: imageURLString)
        self.mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType)?.capitalized
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
    }

}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case it = "it"
    case no = "no"
    case th = "th"
}
