//
//  AddAcounnt.swift
//  
//
//  Created by Marcelo Garcia on 30/09/21.
//

import Foundation

// Quando criamos uma struct, por padrao no ios
// ela é internal e o construtora é criado junto
// mas quando colocamos ela public, por ex nesse caso devido ao Domain
// e precisarmos acessar esse cara de outro framework
// precisamos criar um construtor.
public struct AddAccountModel: Model {
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
    
    public init(name: String, email: String, password: String, passwordConfirmation:String) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}

