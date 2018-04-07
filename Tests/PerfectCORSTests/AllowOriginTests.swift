//
//  AllowOriginTests.swift
//  PerfectCORSTests
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import XCTest
import PerfectHTTP
@testable import PerfectCORS

class AllowOriginTests: XCTestCase {

    func testAllOriginsShouldBeAllowedOnDefault() {

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
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowOrigin) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("*", header)
    }

    func testAllowedOriginShouldBeAllowedWhenIsMatched() {

        // Arrange.
        let corsFilter = CORSFilter(origin: ["server.com", "other.org"])
        let fakeRequest = FakeHTTPRequest(method: .options)
        fakeRequest.setHeader(.origin, value: "server.com")
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowOrigin) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("server.com", header)
    }

    func testOriginShouldNotBeAllowedWhenNotMatched() {

        // Arrange.
        let corsFilter = CORSFilter(origin: ["server.com", "other.org"])
        let fakeRequest = FakeHTTPRequest(method: .options)
        fakeRequest.setHeader(.origin, value: "notmatch.com")
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowOrigin) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("false", header)
    }

    static var allTests = [
        ("testAllOriginsShouldBeAllowedOnDefault", testAllOriginsShouldBeAllowedOnDefault),
        ("testAllowedOriginShouldBeAllowedWhenIsMatched", testAllowedOriginShouldBeAllowedWhenIsMatched),
        ("testOriginShouldNotBeAllowedWhenNotMatched", testOriginShouldNotBeAllowedWhenNotMatched)
    ]
}
