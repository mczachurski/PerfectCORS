//
//  ExposeHeadersTests.swift
//  PerfectCORSTests
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import XCTest
import PerfectHTTP
@testable import PerfectCORS

class ExposeHeadersTests: XCTestCase {

    func testExposeHeadersShouldNotExistsOnDefault() {

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
        let header = fakeResponse.header(.custom(name: "Access-Control-Expose-Headers"))

        if header != nil {
            return XCTFail("Access-Control-Expose-Headers should not exists")
        }
    }

    func testExposedHeadersShouldBeReturnedWhenWasSpecified() {

        // Arrange.
        let corsFilter = CORSFilter(exposedHeaders: [
            HTTPResponseHeader.Name.contentEncoding,
            HTTPResponseHeader.Name.contentLocation
            ])
        let fakeRequest = FakeHTTPRequest(method: .options)
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (_) in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        guard let header = fakeResponse.header(.custom(name: "Access-Control-Expose-Headers")) else {
            return XCTFail("Headers not exists")
        }

        XCTAssertEqual("Content-Encoding, Content-Location", header)
    }

    static var allTests = [
        ("testExposeHeadersShouldNotExistsOnDefault", testExposeHeadersShouldNotExistsOnDefault),
        ("testExposedHeadersShouldBeReturnedWhenWasSpecified", testExposedHeadersShouldBeReturnedWhenWasSpecified)
    ]
}
