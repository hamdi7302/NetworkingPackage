//
//  AuthNetworkManager.swift
//
//
//  Created by hamdi on 23/9/2024.
//

import Foundation
import Combine


public struct CreateSessionForUser: Decodable{
    public var success: Bool
    public var expires_at: String
    public var request_token: String
}

public struct SessionForUser: Decodable{
    public var success: Bool
    public var session_id: String
}

public struct CreateGuestSession: Decodable{
    public var success: Bool
    public var guest_session_id: String
    public var request_token: String
}
protocol AuthProtocol {
    
    // For now we will only guest session
    //  Step 1: create req token for user
    func createRequestToken() -> AnyPublisher<CreateSessionForUser, NetworkError>
    //  Step 2: wait for user approval()
    //  step3: Create the user session
    func createUserSession() -> AnyPublisher<SessionForUser,NetworkError>
    
    
    func createGuestSession() -> AnyPublisher<CreateGuestSession, NetworkError>
}

public class AuthNetworkManager: AuthProtocol {
    
    private let networkManager : NetworkManager
    private let apiKey = "c8eeea30d19c18b002f6f906e9c17475"
    private let baseUrl = "https://api.themoviedb.org/3/"
    
    public init() {
        self.networkManager = NetworkManager()
    }
    
    public func createUserSession() -> AnyPublisher<SessionForUser,NetworkError>{
        let endoint = baseUrl + "authentication/session/new?api_key=\(apiKey)"
        
        var headers: [String:String] = [:]
        headers["accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        
        return networkManager.request(endoint: endoint,
                                      authmethod: .post,
                                      headers: headers,
                                      params: ["request_token" : AuthManager.shared.getAuthToken() ?? ""])
    }
    
    public func createRequestToken() -> AnyPublisher<CreateSessionForUser, NetworkError> {
        let endoint = baseUrl + "authentication/token/new?api_key=\(apiKey)"
        var headers: [String:String] = [:]
        headers["accept"] = "application/json"
        return networkManager.request(endoint: endoint,
                                      headers: headers)
    }
    
    public func createGuestSession() -> AnyPublisher<CreateGuestSession, NetworkError> {
        let endoint = baseUrl + "authentication/guest_session/new?api_key=\(apiKey)"
        var headers: [String:String] = [:]
        headers["accept"] = "application/json"
        return networkManager.request(endoint: endoint,
                                      headers: headers)
    }
    
}
