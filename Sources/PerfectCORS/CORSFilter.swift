//
//  CORSFilter.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import Foundation
import PerfectHTTP

public class CORSFilter: HTTPRequestFilter {

    public let origin: [String]?
    public let methods: [HTTPMethod]?
    public let allowedHeaders: [HTTPRequestHeader.Name]?
    public let exposedHeaders: [HTTPResponseHeader.Name]?
    public let maxAge: Double?
    public let credentials: Bool?

    public init(origin: [String]? = nil,
                methods: [HTTPMethod]? = nil,
                allowedHeaders: [HTTPRequestHeader.Name]? = nil,
                exposedHeaders: [HTTPResponseHeader.Name]? = nil,
                maxAge: Double? = nil,
                credentials: Bool? = nil) {
        self.origin = origin
        self.methods = methods
        self.allowedHeaders = allowedHeaders
        self.exposedHeaders = exposedHeaders
        self.maxAge = maxAge
        self.credentials = credentials
    }

    public func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> Void) {

        if request.method == .options {

            self.configureOrigin(request: request, response: response)
            self.configureMethods(response: response)
            self.configureAllowedHeaders(request: request, response: response)
            self.configureExposedHeaders(response: response)
            self.configureMaxAge(response: response)
            self.configureCredentials(response: response)

            response.status = .ok
            return callback(.halt(request, response))
        } else {

            self.configureOrigin(request: request, response: response)
            self.configureExposedHeaders(response: response)
            self.configureCredentials(response: response)

            return callback(.continue(request, response))
        }
    }

    private func configureCredentials(response: HTTPResponse) {
        if let credentials = self.credentials {
            response.setHeader(.accessControlAllowCredentials, value: credentials == true ? "true" : "false")
        }
    }

    private func configureMaxAge(response: HTTPResponse) {
        if let maxAge = self.maxAge {
            if maxAge > 0 {
                response.setHeader(.accessControlMaxAge, value: String(maxAge))
            }
        }
    }

    private func configureAllowedHeaders(request: HTTPRequest, response: HTTPResponse) {
        if let allowedHeaders = self.allowedHeaders {
            response.setHeader(.accessControlAllowHeaders,
                               value: allowedHeaders.map { $0.standardName }.joined(separator: ", "))
        } else if let requestHeaders = request.header(.accessControlRequestHeaders) {
            response.setHeader(.accessControlAllowHeaders, value: requestHeaders)
        }
    }

    private func configureExposedHeaders(response: HTTPResponse) {
        if let exposeHeaders = self.exposedHeaders {
            response.setHeader(.custom(name: "Access-Control-Expose-Headers"),
                               value: exposeHeaders.map { $0.standardName }.joined(separator: ", "))
        }
    }

    private func configureOrigin(request: HTTPRequest, response: HTTPResponse) {
        if let origin = self.origin {
            if let requestOrigin = request.header(.origin) {
                if origin.index(of: requestOrigin) != nil {
                    response.setHeader(.accessControlAllowOrigin, value: requestOrigin)
                    return
                }
            }

            response.setHeader(.accessControlAllowOrigin, value: "false")
            return
        }

        response.setHeader(.accessControlAllowOrigin, value: "*")
    }

    private func configureMethods(response: HTTPResponse) {
        var allowedMethods: [HTTPMethod] = [.get, .post, .put, .delete, .patch]
        if let methods = self.methods {
            allowedMethods = methods
        }

        response.addHeader(.accessControlAllowMethods,
                           value: allowedMethods.map { $0.description }.joined(separator: ", "))
    }
}
