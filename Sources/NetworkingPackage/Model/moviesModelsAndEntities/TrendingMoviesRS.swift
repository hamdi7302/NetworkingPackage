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
public struct ResultCard: Codable {
    let backdropPath: String
    let id: Int
    let title, originalTitle, overview, posterPath: String
    let mediaType: MediaType
    let adult: Bool
    let originalLanguage: OriginalLanguage
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String
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

public enum OriginalLanguage: String, Codable {
    case en = "en"
}
