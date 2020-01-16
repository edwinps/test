//
//  HTTPProvider.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 14/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import Foundation
import Moya

public protocol HTTPProvider {
    func request<RequestType>(
        _ service: RequestType,
        _ completion: @escaping Completion) where RequestType: TargetType
}

public class HTTPProviderImp: HTTPProvider {
    public let provider: MoyaProvider<MultiTarget>
    
    public init(_ provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    public convenience init() {
        // configure a custom MoyaProvider
        // https://github.com/Moya/Moya/blob/master/docs/Endpoints.md
        let endpointClosure = { (target: MultiTarget) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint.adding(newHTTPHeaderFields: ["APP_NAME": "Safe365"])
        }
        
        // add the logger plugin
        let loggingPlugin = NetworkLoggerPlugin(verbose: false)
        
        // create the innerRequester using a MoyaProvider
        let moyaProvider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure,
                                                     plugins: [loggingPlugin])
        self.init(moyaProvider)
    }
    
    public convenience init(endpointClosure: @escaping (MultiTarget) -> Endpoint) {
        // add the logger plugin
        let loggingPlugin = NetworkLoggerPlugin(verbose: true)
        
        // create the innerRequester using a MoyaProvider
        let moyaProvider = MoyaProvider<MultiTarget>(endpointClosure: endpointClosure,
                                                     stubClosure: MoyaProvider.immediatelyStub,
                                                     plugins: [loggingPlugin])
        self.init(moyaProvider)
    }
    
    public func request<RequestType>(
        _ service: RequestType,
        _ completion: @escaping Completion) where RequestType: TargetType {
        provider.request(MultiTarget(service), completion: completion)
    }
}
