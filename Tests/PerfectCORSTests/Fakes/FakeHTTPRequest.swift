//
//  FakeHTTPRequest.swift
//  TaskerServerLibTests
//
//  Created by Marcin Czachurski on 14.02.2018.
//

import Foundation
import PerfectHTTP
import PerfectNet
@testable import PerfectCORS

class FakeHTTPRequest: HTTPRequest {

    var method: HTTPMethod = HTTPMethod.get
    var path: String = ""
    var pathComponents: [String] = []
    var queryParams: [(String, String)] = []
    var protocolVersion: (Int, Int) = (1, 0)
    var remoteAddress: (host: String, port: UInt16) = ("", 0)
    var serverAddress: (host: String, port: UInt16) = ("", 0)
    var serverName: String = ""
    var documentRoot: String = ""
    var connection: NetTCP = NetTCP()
    var urlVariables: [String: String] = [:]
    var scratchPad: [String: Any] = [:]
    var headers: AnyIterator<(HTTPRequestHeader.Name, String)> = AnyIterator { return nil }
    var postParams: [(String, String)] = []
    var postBodyBytes: [UInt8]?
    var postBodyString: String?
    var postFileUploads: [MimeReader.BodySpec]?

    var headersArray: [HTTPRequestHeader.Name: String] = [:]

    init() {
    }

    init(method: HTTPMethod) {
        self.method = method
    }

    func addHeader(_ named: HTTPRequestHeader.Name, value: String) {
        headersArray[named] = value
    }

    func setHeader(_ named: HTTPRequestHeader.Name, value: String) {
        headersArray[named] = value
    }

    func header(_ named: HTTPRequestHeader.Name) -> String? {
        return headersArray[named]
    }
}
