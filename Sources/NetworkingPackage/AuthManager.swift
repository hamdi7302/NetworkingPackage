//
//  AuthManager.swift
//
//
//  Created by hamdi on 22/9/2024.
//

import Foundation
import Security

public class AuthManager {
    
    public static var shared = AuthManager()
    
    private var authToken: CreatedToken?//  this is only to create a session in order to approve by TMDB Servidce
    
    func getAuthToken() -> String? {
        return authToken?.token
    }
    
    public func setAuthToken(createdToken: CreatedToken  ) {
        authToken = createdToken
    }
    
    func getSession() -> Result<Session?,SessionStatus> {
        let (data, status)  = KeychainManager().retrieve()
        
        guard  let data = data,
               let session = try? JSONDecoder().decode(Session.self, from: data) else {
            return .failure(.noSession)
        }
        
        if session.expiredAt <= Date() {
            return .failure(.sessionExipred)
        }
        return .success(session)
    }
    
    func setSession(_ userSession: Session) {
        KeychainManager().save(session: userSession)
    }
}
