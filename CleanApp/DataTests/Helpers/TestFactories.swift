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

func makeUrl() -> URL {
    return URL(string:"http://any-url.com")!
}
