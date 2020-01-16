//
//  BaseService.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose.
//

import Foundation
import Moya
import Result

public class BaseService: TargetType {
    public var baseURL: URL {
        let url = "https://api-dev.alpify.com:3005"
        return URL(string: url)!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var parameters: [String: Any]? {
        return nil
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var sampleData: Data {
        return "Sample data".utf8Encoded
    }
    
    public var task: Task {
        guard let params = parameters else { return .requestPlain }
        return .requestParameters(parameters: params, encoding: parameterEncoding)
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    func stubbedData(_ filename: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            debugPrint(filename + ".json" + " doesnt exist")
            return "".utf8Encoded
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            return (jsonData)
        } catch {
            debugPrint("there are problems with the Json of test")
            return ("".utf8Encoded)
        }
    }
}
