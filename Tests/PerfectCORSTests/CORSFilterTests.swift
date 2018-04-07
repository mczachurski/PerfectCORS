import XCTest
import PerfectHTTP
@testable import PerfectCORS

class CORSFilterTests: XCTestCase {

    func testOptionsHTTPMethodShouldStopRequestChain() {

        // Arrange.
        let corsFilter = CORSFilter()
        let fakeRequest = FakeHTTPRequest(method: .options)
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")
        var requestFilterResult: HTTPRequestFilterResult?

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (result) in
            requestFilterResult = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        XCTAssertEqual(HTTPRequestFilterResult.halt(fakeRequest, fakeResponse), requestFilterResult)
    }

    func testGetHTTPMethodShouldNotStopRequestChain() {

        // Arrange.
        let corsFilter = CORSFilter()
        let fakeRequest = FakeHTTPRequest(method: .get)
        let fakeResponse = FakeHTTPResponse()
        let expectation = self.expectation(description: "Callback")
        var requestFilterResult: HTTPRequestFilterResult?

        // Act.
        corsFilter.filter(request: fakeRequest, response: fakeResponse) { (result) in
            requestFilterResult = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        // Assert.
        XCTAssertEqual(HTTPRequestFilterResult.continue(fakeRequest, fakeResponse), requestFilterResult)
    }

    func testOptionsHTTPMethodShouldSetOkInResponseCode() {

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
        XCTAssertEqual(HTTPResponseStatus.ok.code, fakeResponse.status.code)
    }

    static var allTests = [
        ("testOptionsHTTPMethodShouldStopRequestChain", testOptionsHTTPMethodShouldStopRequestChain),
        ("testGetHTTPMethodShouldNotStopRequestChain", testGetHTTPMethodShouldNotStopRequestChain),
        ("testOptionsHTTPMethodShouldSetOkInResponseCode", testOptionsHTTPMethodShouldSetOkInResponseCode)
    ]
}
