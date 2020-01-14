//
//  DateExtension .swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 14/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation

extension Date {
    func format(_ format: String = "yyyy-MM-dd HH:mm:ss zzz", identifierLocal: String = "UTC") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifierLocal)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
