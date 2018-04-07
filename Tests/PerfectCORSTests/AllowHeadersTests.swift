//
//  AllowHeadersTests.swift
//  PerfectCORSTests
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import XCTest
import PerfectHTTP
@testable import PerfectCORS

class AllowHeadersTests: XCTestCase {

    func testAllHeadersFromRequestShouldBeAllowedOnDefault() {

        // Arrange.
        let corsFilter = CORSFilter()
        let fakeRequest = FakeHTTPRequest(method: .options)
        fakeRequest.setHeader(.accessControlRequestHeaders, value: "Accept-Language, Authorization")
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowHeaders) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("Accept-Language, Authorization", header)
    }

    func testOnlyAllowedHeadersShouldBeAllowedWhenWasSpecified() {

        // Arrange.
        let corsFilter = CORSFilter(allowedHeaders: [
            HTTPRequestHeader.Name.acceptLanguage,
            HTTPRequestHeader.Name.userAgent
            ])
        let fakeRequest = FakeHTTPRequest(method: .options)
        fakeRequest.setHeader(.accessControlRequestHeaders, value: "Accept-Language, Authorization")
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowHeaders) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("Accept-Language, User-Agent", header)
    }

    static var allTests = [
        ("testAllHeadersFromRequestShouldBeAllowedOnDefault", testAllHeadersFromRequestShouldBeAllowedOnDefault),
        ("testOnlyAllowedHeadersShouldBeAllowedWhenWasSpecified", testOnlyAllowedHeadersShouldBeAllowedWhenWasSpecified)
    ]
}
