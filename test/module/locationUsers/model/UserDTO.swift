//
//  UserDTO.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 14/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation

enum Motion: String, Codable {
    case walk
    case run
    case vehicle
    case bicycle
    case still
    case empty = ""
}

struct UserDTO: Codable {
    let name: String?
    let avatar: String?
    let motion: Motion?
    let timestamp: String?
    let latitude: Double?
    let longitude: Double?
}

