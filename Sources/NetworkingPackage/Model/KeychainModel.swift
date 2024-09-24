//
//  KeychainModel.swift
//
//
//  Created by hamdi on 24/9/2024.
//

import Foundation

public struct Session: Codable{
    let token: String
    let expiredAt: Date
    let guestSession: Bool
}

enum SessionStatus: Error{
    case noSession
    case sessionExipred
}

