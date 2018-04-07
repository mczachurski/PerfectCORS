//
//  AccessControlAllowMethodsTests.swift
//  PerfectCORSTests
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import XCTest
import PerfectHTTP
@testable import PerfectCORS

class AllowMethodsTests: XCTestCase {

    func testAllDefaultAllowedMethodsShouldBeReturned() {

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
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowMethods) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("GET, POST, PUT, DELETE, PATCH", header)
    }

    func testOnlyCustomAllowedMethodsShouldBeReturned() {

        // Arrange.
        let corsFilter = CORSFilter(methods: [.get, .post])
        let fakeRequest = FakeHTTPRequest(method: .options)
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(HTTPResponseHeader.Name.accessControlAllowMethods) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("GET, POST", header)
    }

    static var allTests = [
        ("testAllDefaultAllowedMethodsShouldBeReturned", testAllDefaultAllowedMethodsShouldBeReturned),
        ("testOnlyCustomAllowedMethodsShouldBeReturned", testOnlyCustomAllowedMethodsShouldBeReturned)
    ]
}
