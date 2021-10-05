//
//  DataTests.swift
//  DataTests
//
//  Created by Marcelo Garcia on 05/10/21.
//

import XCTest

class RemoteAddAccount{
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url:URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(){
        httpClient.post(url: url)
    }
}

// interface segregation principle para ter pequenas interfaces por protocolo
protocol HttpPostClient {
    func post(url: URL)
}

class RemoteAddAccountTests: XCTestCase {
    func test_(){
        let url = URL(string:"http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        // serve para identificar a classe que estou testando
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        sut.add()
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    // Faz uma implementaçao fake do protocolo httpclient
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        func post(url: URL) {
            self.url = url
        }
    }
}
