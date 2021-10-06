//
//  Model.swift
//  Domain
//
//  Created by Marcelo Garcia on 05/10/21.
//

import Foundation
public protocol Model:Codable, Equatable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
