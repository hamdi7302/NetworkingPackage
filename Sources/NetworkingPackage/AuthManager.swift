//
//  File.swift
//  
//
//  Created by hamdi on 22/9/2024.
//

import Foundation


public class AuthManager {
    
    public static var shared = AuthManager()
    
    private var authToken: String?
    

    func getAuthToken() -> String {
        // Retrieve the token from UserDefaults (though Keychain is recommended)
        return UserDefaults.standard.string(forKey: "token")!
    }

    public func setAuthToken(_ userTokenSession: String) {
        // Save the token in UserDefaults (use Keychain for better security)
        UserDefaults.standard.setValue(userTokenSession, forKey: "token")
    }
    
    public func setUserSession(userTokenSession: String) {
        UserDefaults.standard.setValue(userTokenSession, forKey: "userSession")
    }
    
 
    
}

