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

protocol AppService {
    func fetchAllTrending (trendingType: TrendingType) -> AnyPublisher<TrendingMovies,NetworkError>
}

public class MovieNetworkManager: AppService {
    
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

// https://image.tmdb.org/t/p/w500/
