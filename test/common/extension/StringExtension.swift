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
}
