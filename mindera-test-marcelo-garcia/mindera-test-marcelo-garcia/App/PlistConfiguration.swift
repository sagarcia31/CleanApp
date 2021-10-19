//
//  PlistConfiguration.swift
//  mindera-test-marcelo-garcia
//
//  Created by Marcelo Garcia on 06/10/21.
//

import Foundation
public enum PlistKey {
    case ApiURL
    case ApiKey
    
    func value() -> String {
        switch self {
        case .ApiURL:
            return "API_URL"
        case .ApiKey:
            return "API_KEY"
        }
    }
}

public enum EndpointPlistKey {
    case imageList
    case getImage
    
    func value() -> String {
        switch self {
        case .imageList:
            return "LIST_IMAGES"
            
        case .getImage:
            return "GET_IMAGES"
        }
    }
}

public struct Environment {
    
    fileprivate var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    
    fileprivate var endPointDict: NSDictionary {
        get {
            var dict: NSDictionary?
            if let path = Bundle.main.path(forResource: "Endpoints", ofType: "plist") {
                dict = NSDictionary(contentsOfFile: path)
                return dict!
            } else {
                fatalError("Plist file not found")
            }
        }
    }
    
    public func getUrlFrom(endPoint: EndpointPlistKey, parameters:[String]=[""]) -> String {
        guard let baseUrl = infoDict[PlistKey.ApiURL.value()] as? String else {
            return ""
        }
        
        guard let apiKey = infoDict[PlistKey.ApiKey.value()] as? String else {
            return ""
        }
        
        guard let endPoint = endPointDict[endPoint.value()] as? String else {
            return ""
        }
        
        let url = baseUrl + String(format: endPoint, apiKey)
        
        guard parameters.count > 0 else {
            return  url
        }
        
        var returnUrl = url
        for item in parameters {
            returnUrl +=  item
        }
        
        return returnUrl
    }
}
