//
//  DataTests.swift
//  DataTests
//
//  Created by Marcelo Garcia on 05/10/21.
//

import XCTest
@testable import Data
@testable import Domain


class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_httpClient_with_correct_url(){
        let url = URL(string:"http://any-url.com")!
        let (sut, httpClientSpy) = makeSut()
        sut.add(addAccountModel: makeAddAccountModel()) {_ in}
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data(){
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel) {_ in}
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_error(){
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure(let error):XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error receive \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_data(){
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expextedAccount = makeAccountModel()
        
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure: XCTFail("Expected success receive \(result) instead")
            case .success(let receivedAccount): XCTAssertEqual(receivedAccount, expextedAccount)
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(expextedAccount.toData()!)
        wait(for: [exp], timeout: 1)
    }
}

extension RemoteAddAccountTests {
    // Factory para criaçao do sut
    func makeSut(url:URL = URL(string:"http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy:HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    //Factory para criaçao de conta
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email@email.com", password: "any_password", passwordConfirmation: "any_password")
    }
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(id:"1", name: "any_name", email: "any_email@email.com", password: "any_password")
    }
    
    // Faz uma implementaçao fake do protocolo httpclient
    class HttpClientSpy: HttpPostClient {
        var urls = [URL]()
        var data: Data?
        var completion: ((Result<Data, HttpError>)-> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping(Result<Data, HttpError>)->Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
}