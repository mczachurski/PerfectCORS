//
//  AllowCredentialsTests.swift
//  PerfectCORSTests
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import XCTest
import PerfectHTTP
@testable import PerfectCORS

class AllowCredentialsTests: XCTestCase {

    func testAllowCredentialsShouldNotExistsOnDefault() {

        // Arrange.
        let corsFilter = CORSFilter()
        let fakeRequest = FakeHTTPRequest(method: .options)
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowCredentials)

        if header != nil {
            return XCTFail("Access-Control-Allow-Credentials should not exists")
        }
    }

    func testAllowCredentialsHeaderShouldContainsTrueIfWasSpecified() {

        // Arrange.
        let corsFilter = CORSFilter(credentials: true)
        let fakeRequest = FakeHTTPRequest(method: .options)
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowCredentials) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("true", header)
    }

    func testAllowCredentialsHeaderShouldContainsFalseIfWasSpecified() {

        // Arrange.
        let corsFilter = CORSFilter(credentials: true)
        let fakeRequest = FakeHTTPRequest(method: .options)
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowCredentials) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("true", header)
    }

    static var allTests = [
        ("testAllowCredentialsShouldNotExistsOnDefault", testAllowCredentialsShouldNotExistsOnDefault),
        ("testAllowCredentialsHeaderShouldContainsTrueIfWasSpecified", testAllowCredentialsHeaderShouldContainsTrueIfWasSpecified),
        ("testAllowCredentialsHeaderShouldContainsFalseIfWasSpecified", testAllowCredentialsHeaderShouldContainsFalseIfWasSpecified)
    ]

}
