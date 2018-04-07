//
//  FakeHTTPResponse.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 14.02.2018.
//

import Foundation
import PerfectHTTP
@testable import PerfectCORS

class FakeHTTPResponse: HTTPResponse {

    var request: HTTPRequest = FakeHTTPRequest()
    var status: HTTPResponseStatus = HTTPResponseStatus.ok
    var isStreaming: Bool = false
    var bodyBytes: [UInt8] = []
    var headers: AnyIterator<(HTTPResponseHeader.Name, String)> = AnyIterator { return nil }

    var headersArray: [(key: HTTPResponseHeader.Name, value: String)] = []

    init() {
    }

    func header(_ named: HTTPResponseHeader.Name) -> String? {
        let headerElement = headersArray.first { (key, _) -> Bool in
            return key == named
        }

        return headerElement?.value
    }

    func addHeader(_ named: HTTPResponseHeader.Name, value: String) -> Self {
        headersArray.append((key: named, value: value))
        return self
    }

    func setHeader(_ named: HTTPResponseHeader.Name, value: String) -> Self {
        headersArray.append((key: named, value: value))
        return self
    }

    func push(callback: @escaping (Bool) -> Void) {
    }

    func next() {
    }

    func completed() {
    }
}
