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
        let url = makeUrl()
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
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data(){
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_data(){
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
    
        expect(sut, completeWith: .success(account), when: {
            httpClientSpy.completeWithData(account.toData()!)
        })
    }
    
    func test_add_should_not_complete_if_sut_has_been_deallocated(){
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: makeUrl(), httpClient: httpClientSpy)
        var result:(Result<AccountModel, DomainError>)?
        sut?.add(addAccountModel: makeAddAccountModel()) {result = $0}
        sut = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {
    // Factory para criaçao do sut
    func makeSut(url:URL = URL(string:"http://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteAddAccount, httpClientSpy:HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        
        return (sut, httpClientSpy)
    }
    
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        // Esse cara serve para verificar se existe algum memory leak dentro do SUT,
        // por exemplo dentro do Remote addACount se eu colocar uma referencia dele dentro da implementaçao no callback do protocolo do httpPoStClient já da  bug
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
    
    func makeInvalidData() -> Data {
        return Data("invalid data".utf8)
    }
    
    func makeUrl() -> URL {
        return URL(string:"http://any-url.com")!
    }
    
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line){
        
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)):XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expecteAccount), .success(let receivedAccount)):XCTAssertEqual(expecteAccount, receivedAccount, file: file, line: line)
                
            default: XCTFail("Expected error receive \(expectedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
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
