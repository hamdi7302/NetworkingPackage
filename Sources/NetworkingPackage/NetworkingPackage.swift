// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Combine

enum NetworkError: Error {
    case decodableError
    case networkError
    case unkownError
    case unvalidUrl
    
}

protocol NetworkService{
    func request<T:Decodable>(endoint: String) -> AnyPublisher<T, NetworkError>
}

struct DefaultNetworkService: NetworkService {
    func request<T>(endoint: String) -> AnyPublisher<T, NetworkError> where T : Decodable {
        
        guard let urlReq = URL(string: endoint) else {
            return Fail(error: NetworkError.unvalidUrl).eraseToAnyPublisher()
        }
        
        let res = URLSession.shared.dataTaskPublisher(for: urlReq)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return   error is DecodingError ? NetworkError.decodableError : NetworkError.unkownError
            }.eraseToAnyPublisher()
        
        return res
    }
}

struct UserInfo: Decodable {
    var username: String
    var email: String
    var password: String
}

protocol AuthServiceProtocol {
    func login(username: String, password: String) -> AnyPublisher<UserInfo, NetworkError>
}

//  may be need to chane to class later
struct AuthService: AuthServiceProtocol {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func login(username: String, password: String) -> AnyPublisher<UserInfo, NetworkError> {
        let endoint = ""
        return networkService.request(endoint: "")
    }
    
}
