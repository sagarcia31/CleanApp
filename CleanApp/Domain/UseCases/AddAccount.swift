//
//  AddAccount.swift
//  Domain
//
//  Created by Marcelo Garcia on 05/10/21.
//

import Foundation

public protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completion: @escaping (Result<AccountModel, DomainError>) -> Void)
}
