//
//  File.swift
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

protocol AuthProtocol {
    
    //  Step 1: create req token for user
    func createRequestToken() -> AnyPublisher<CreateSessionForUser, NetworkError>
    //  Step 2: wait for user approval()
    //  step3: Create the user session
    func createUserSession() -> AnyPublisher<SessionForUser,NetworkError>
}

public class AuthNetworkManager: AuthProtocol {
    
    
    private  let networkManager : NetworkManager
    
    public init() {
        self.networkManager = NetworkManager()
    }
    
    public func createUserSession() -> AnyPublisher<SessionForUser,NetworkError>{
        let endoint = "https://api.themoviedb.org/3/authentication/session/new?api_key="
        
        var headers: [String:String] = [:]
        headers["accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        
        return networkManager.request(endoint: endoint,
                                      authmethod: .post,
                                      headers: headers,
                                      params: ["request_token" : AuthManager.shared.getAuthToken()])
        
    }
    
    public func createRequestToken() -> AnyPublisher<CreateSessionForUser, NetworkError> {
        let endoint = "https://api.themoviedb.org/3/authentication/token/new?api_key="
        var headers: [String:String] = [:]
        headers["accept"] = "application/json"
        return networkManager.request(endoint: endoint, headers: headers)
    }
}
