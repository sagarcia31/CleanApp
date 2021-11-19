//
//  TestFactories.swift
//  DataTests
//
//  Created by Marcelo Garcia on 06/10/21.
//

import Foundation

func makeInvalidData() -> Data {
    return Data("invalid data".utf8)
}

func makeValidData() -> Data {
    return Data("{\"name\":\"Marcelo\"}".utf8)
}

func makeUrl() -> URL {
    return URL(string:"http://any-url.com")!
}

func makeError() -> Error {
    return NSError(domain: "any_error", code: 0)
}

func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
    return HTTPURLResponse(url: makeUrl(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
