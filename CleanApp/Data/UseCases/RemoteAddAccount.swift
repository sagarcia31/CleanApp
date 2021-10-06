//
//  RemoteAddAccount.swift
//  Domain
//
//  Created by Marcelo Garcia on 05/10/21.
//

import Foundation
import Domain

class RemoteAddAccount{
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url:URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (DomainError) -> Void){
        httpClient.post(to: url, with: addAccountModel.toData()) { error in
            completion(.unexpected)
        }
    }
}
