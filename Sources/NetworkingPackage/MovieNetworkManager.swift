//
//  MovieNetworkManager.swift
//
//
//  Created by hamdi on 24/9/2024.
//


import SwiftUI
import Combine

public enum NetworkError: Error {
    case decodableError
    case networkError
    case unkownError
    case unvalidUrl
    case notimplementedyet
    case unableTofetchImage
}

struct UserInfo: Decodable {
    var username: String
    var email: String
    var password: String
}

public enum TrendingType: String {
    case day
    case week
}


public struct Genres: Decodable {
    let genres: [Genre]
}

// MARK: - Genre
public struct Genre: Decodable {
    let id: Int
    let name: String
}

public enum GenreType: String {
    case tv
    case movie
}

protocol AppService {
    func fetchAllTrending (trendingType: TrendingType) -> AnyPublisher<TrendingMovies,NetworkError>
    func fetchImage(posterPath : String) -> AnyPublisher <UIImage?,NetworkError>
    func fetchMoviesGenre(forMovie: GenreType) -> AnyPublisher<Genres,NetworkError>
}

public class MovieNetworkManager: AppService {
    
    // inclsue as @EnvironmentObject  in Datamodel  with the type tv or movies
    public func fetchMoviesGenre(forMovie: GenreType) -> AnyPublisher<Genres,NetworkError> {
        var endoint = "'https://api.themoviedb.org/3/genre/\(forMovie)/list?language=en'"
        endoint.append("?api_key=\(apiKey)") // to remove and append header user session
        // to replace token with user token
        return networkManager.request(endoint: endoint)
    }
    
    public func fetchImage(posterPath: String) -> AnyPublisher <UIImage?,NetworkError> {
        var endoint = "https://image.tmdb.org/t/p/w1280\(posterPath)"
        // to remove and append header user session
        
        // to replace token with user token
        return networkManager.fetchAndCacheImage(endoint: endoint)
    }
    
    
    private let apiKey = "c8eeea30d19c18b002f6f906e9c17475"
    let networkManager: NetworkManager
    
    public func fetchAllTrending(trendingType: TrendingType) -> AnyPublisher<TrendingMovies, NetworkError> {
        
        var endoint = "https://api.themoviedb.org/3/trending/movie/\(trendingType)"
        endoint.append("?api_key=\(apiKey)") // to remove and append header user session
        
        // to replace token with user token
        return networkManager.request(endoint: endoint)
    }
   public init() {
        self.networkManager = NetworkManager()
    }
}

 
