//
//  RemoteAddAccount.swift
//  Domain
//
//  Created by Marcelo Garcia on 05/10/21.
//

import Foundation
import Domain

class RemoteAddAccount: AddAccount
{
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url:URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void){
        httpClient.post(to: url, with: addAccountModel.toData()) { result  in
            switch result {
            case .success(let data):
                if let model:AccountModel = data.toModel() {
                    completion(.success(model))
                }
            case .failure:
                completion(.failure(.unexpected))
            }
        }
    }
}

