//
//  CreatedTokenModel.swift
//  
//
//  Created by hamdi on 24/9/2024.
//

import Foundation

public struct CreatedToken{
    
    public init(token: String, expiresAt: Date?) {
        self.token = token
        self.expiresAt = expiresAt
    }
    
    let token: String
    let expiresAt: Date?
}

