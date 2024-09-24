//
//  File.swift
//  
//
//  Created by hamdi on 24/9/2024.
//

import Foundation

public struct KeychainManager {
    private static let  serviceName = "MyMovieApp"
    public static func save(session: Session) -> OSStatus {
        
        guard let sessionData = try? JSONEncoder().encode(session) else {
            return errSecParam
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // most used to save token or pass , etc  ..
            kSecAttrAccount as String: session.token, // identifier
            kSecValueData as String: sessionData,   // session endoded
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked, // security
            kSecAttrService as String: serviceName , // to disting from other app keycahin
        ]
        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    public static func retrieve(by serviceName: String) -> (data: Data?, error: OSStatus) {
        
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName
        ]
        var ref: AnyObject? = nil
        let oStatus =  SecItemCopyMatching(query as CFDictionary, &ref)
        
        if oStatus == errSecSuccess , let data = ref as? Data {
            return (data , errSecSuccess)
        }
        return (nil, oStatus)
    }
}

