//
//  TestExtensions.swift
//  DataTests
//
//  Created by Marcelo Garcia on 06/10/21.
//

import XCTest
@testable import Data
@testable import Domain

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        // Esse cara serve para verificar se existe algum memory leak dentro do SUT,
        // por exemplo dentro do Remote addACount se eu colocar uma referencia dele dentro da implementaçao no callback do protocolo do httpPoStClient já da  bug
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}


