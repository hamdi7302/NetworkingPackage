//
//  File.swift
//  
//
//  Created by hamdi on 24/9/2024.
//

import Foundation

extension String {
    // Method to convert a date string to a Date object
    public func toDate(using format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
