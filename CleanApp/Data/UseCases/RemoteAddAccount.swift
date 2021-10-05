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
    
    init(url:URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(addAccountModel: AddAccountModel){
        httpClient.post(to: url, with: addAccountModel.toData())
    }
}
