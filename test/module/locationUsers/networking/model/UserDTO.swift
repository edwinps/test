//
//  UserDTO.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 14/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation

struct UserDTO: Codable {
    let name: String?
    let avatar: String?
    let motion: String?
    let timestamp: String?
    let latitude: Double?
    let longitude: Double?
}
