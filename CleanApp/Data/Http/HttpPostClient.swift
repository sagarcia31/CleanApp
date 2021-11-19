//
//  HttpPostClient.swift
//  Data
//
//  Created by Marcelo Garcia on 05/10/21.
//

import Foundation

// interface segregation principle para ter pequenauus interfaces por protocolo
public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?,HttpError>) -> Void)
}
