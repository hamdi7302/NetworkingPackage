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


struct Movie: Decodable{
    
}

protocol AppService {
//    func fetchmovies () -> AnyPublisher<[Movie],NetworkError>
}

struct MovieNetworkManager: AppService {
    
    let networkManager: NetworkManager
    
    init(networkService: NetworkService) {
        self.networkManager = NetworkManager()
    }
   
//    func fetchmovies() -> AnyPublisher<[Movie], NetworkError> {
//        let endoint = ""
//        return networkManager.request(endoint: endoint, headers: ["token" : AuthManager.shared.getAuthToken()])
//    }
}

