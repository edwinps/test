//
//  UserService.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 14/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation
import Moya
import Result

class UserService: BaseService {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override var path: String {
        return "/mobiletest/users"
    }
    
    public override var method: Moya.Method {
        return .post
    }
    
    override var headers: [String: String]? {
        let headers: [String: String] = ["Accept": "application/json",
            "Content-Type": "application/json"
        ]
        return headers
    }
    
    public override var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public override var task: Task {
        return .requestParameters(parameters: ["latitude": self.latitude,
                                               "longitude": self.longitude],
                                  encoding: URLEncoding.default)
        
    }
    
    public override var sampleData: Data {
        return self.stubbedData("UserService")
    }
}
