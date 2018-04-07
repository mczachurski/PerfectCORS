//
//  MaxAgeTests.swift
//  PerfectCORSTests
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import XCTest
import PerfectHTTP
@testable import PerfectCORS

class MaxAgeTests: XCTestCase {

    func testMaxAgeShouldNotExistsOnDefault() {

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
        let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlMaxAge)

        if header != nil {
            return XCTFail("Access-Control-Max-Age should not exists")
        }
    }

    func testMaxAgeShouldBeReturnedWhenWasSpecified() {

        // Arrange.
        let corsFilter = CORSFilter(maxAge: 12.5)
        let fakeRequest = FakeHTTPRequest(method: .options)
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlMaxAge) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("12.5", header)
    }

    static var allTests = [
        ("testMaxAgeShouldNotExistsOnDefault", testMaxAgeShouldNotExistsOnDefault),
        ("testMaxAgeShouldBeReturnedWhenWasSpecified", testMaxAgeShouldBeReturnedWhenWasSpecified)
    ]
}
