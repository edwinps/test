//
//  StringExtension.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 14/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation

extension String {
    public var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
    
    func format(_ format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", identifierLocal: String = "UTC") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let dateObj = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
            return dateFormatter.string(from: dateObj)
        }
        return ""
    }
}
