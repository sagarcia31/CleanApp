//
//  DataTests.swift
//  DataTests
//
//  Created by Marcelo Garcia on 05/10/21.
//

import XCTest
@testable import Data
@testable import Domain

class RemoteAddAccount{
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url:URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(addAccountModel: AddAccountModel){
        let data = try? JSONEncoder().encode(addAccountModel)
        httpClient.post(to: url, with: data)
    }
}

// interface segregation principle para ter pequenauus interfaces por protocolo
protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}

class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_httpClient_with_correct_url(){
        let url = URL(string:"http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        // serve para identificar a classe que estou testando
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        sut.add(addAccountModel: makeAccountModel())
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_httpClient_with_correct_data(){
        let httpClientSpy = HttpClientSpy()
        // serve para identificar a classe que estou testando
        let sut = RemoteAddAccount(url: URL(string:"http://any-url.com")!, httpClient: httpClientSpy)
        let addAccountModel = makeAccountModel()
        sut.add(addAccountModel: addAccountModel)
        let data = try? JSONEncoder().encode(addAccountModel) 
        XCTAssertEqual(httpClientSpy.data, data)
    }
}

extension RemoteAddAccountTests {
    func makeAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email@email.com", password: "any_password", passwordConfirmation: "any_password")
    }
    // Faz uma implementaçao fake do protocolo httpclient
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
