//
//  CORSFilter.swift
//  TaskerServerLib
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import Foundation
import PerfectHTTP

public class CORSFilter: HTTPRequestFilter {

    /**
        List of allowed origins.

        Configures the values returned in Access-Control-Allow-Origin header
        ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin)).
        If list is empty all origins are allowed.
     */
    public let origin: [String]?

    /**
        List of allowed HTTP methods.

        Configures the values returned in Access-Control-Allow-Methods header
        ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Methods)).
        If list is empty methods: `GET`, `POST`, `PUT`, `DELETE`, `PATCH` are allowed.
    */
    public let methods: [HTTPMethod]?

    /**
        List of allowed HTTP headers.

        Configures the values returned in Access-Control-Allow-Headers header
        ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Headers)).
        If list is empty all headers from request are allowed.
    */
    public let allowedHeaders: [HTTPRequestHeader.Name]?

    /**
        List of exposed HTTP headers.

        Configures the values returned in Access-Control-Expose-Headers header
        ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Expose-Headers)).
        If list is empty no custom headers are exposed.
    */
    public let exposedHeaders: [HTTPResponseHeader.Name]?

    /**
        Information about CORS cache.

        Configures the value returned in Access-Control-Max-Age header. Indicates how long
        the results of a preflight request (that is the information contained in the
        Access-Control-Allow-Methods and Access-Control-Allow-Headers headers) can be cached
        ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Expose-Headers)).
        If is not specified header is omitted.
    */
    public let maxAge: Double?

    /**
        Information about exposing credentials header.

        Configures the value returned in Access-Control-Allow-Credentials.
        The Access-Control-Allow-Credentials response header indicates whether or not the
        response to the request can be exposed to the page. It can be exposed when the true
        value is returned
        ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials)).
        If is not specified header is omitted.
    */
    public let credentials: Bool?

    /**
        Filter initialization.

        - Parameters:
            - origin: List of allowed origins.
            - methods: List of allowed HTTP methods.
            - allowedHeaders: List of allowed HTTP headers.
            - exposedHeaders: List of exposed HTTP headers.
            - maxAge: Information about CORS cache.
            - credentials: Information about exposing credentials header.
    */
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

    /**
        Perfect server filter. Called once after the request has been read but before any handler is executed.
    */
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
        if let maxAge = self.maxAge, maxAge > 0 {
            response.setHeader(.accessControlMaxAge, value: String(maxAge))
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

            if let requestOrigin = request.header(.origin), origin.index(of: requestOrigin) != nil {
                response.setHeader(.accessControlAllowOrigin, value: requestOrigin)
                return
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
