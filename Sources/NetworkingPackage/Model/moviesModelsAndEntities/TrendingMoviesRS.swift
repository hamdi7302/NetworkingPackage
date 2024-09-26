//
//  File.swift
//  
//
//  Created by hamdi on 25/9/2024.
//

import Foundation

// Netwoek entity
import Foundation

// MARK: - Welcome
public struct TrendingMovies: Codable {
    let page: Int
    public let results: [ResultCard]
    let totalPages, totalResults: Int

    public enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
public struct ResultCard: Codable, Hashable {
    public let backdropPath: String
    public let id: Int
    public let title, originalTitle, overview, posterPath: String
    public let mediaType: MediaType
    let adult: Bool
    let originalLanguage: String
    let genreIDS: [Int]
    let popularity: Double
    public let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    public enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

public enum MediaType: String, Codable {
    case movie = "movie"
}

//public enum OriginalLanguage: String, Codable {
//    case en = "en"
//}
