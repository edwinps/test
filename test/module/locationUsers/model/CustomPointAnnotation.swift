//
//  CustomPointAnnotation.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 16/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation
import MapKit

class CustomPointAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let user: UserDTO

    init(user: UserDTO, coordinate: CLLocationCoordinate2D) {
        self.user = user
        self.title = user.name
        self.coordinate = coordinate
    }
}
