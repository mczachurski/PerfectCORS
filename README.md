# PerfectCORS

[![Build Status](https://travis-ci.org/mczachurski/PerfectCORS.svg?branch=master)](https://travis-ci.org/mczachurski/PerfectCORS) [![codecov](https://codecov.io/gh/mczachurski/PerfectCORS/branch/master/graph/badge.svg)](https://codecov.io/gh/mczachurski/PerfectCORS) [![codebeat badge](https://codebeat.co/badges/98d92df5-217c-4399-a452-6f75e3c55e8e)](https://codebeat.co/projects/github-com-mczachurski-perfectcors-master) [![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](ttps://developer.apple.com/swift/) [![Platforms OS X | Linux](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat)](https://developer.apple.com/swift/) 

PerfectCORS is a Swift package which enables [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) in server side Swift projects hosted by [Perfect](https://www.perfect.org) server.

## Installation

### Swift Package Manager

To install PerfectCORS with package manager add dependencies to your `Package.swift` file.

```
import PackageDescription

let package = Package(
    name: "YourApp",
    products: [
        .library(name: "YourApp", targets: ["YourApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mczachurski/PerfectCORS.git", from: "1.2.1")
    ],
    targets: [
        .target(name: "YourApp", dependencies: ["PerfectCORS"]),
        .testTarget(name: "YourAppTest", dependencies: ["YourApp"]),
    ]
)
```

## Usage

### Enable all CORS requests

```
import PerfectHTTP
import PerfectHTTPServer
 
// Register your own routes and handlers
var routes = Routes()

// Create CORS filter.
let corsFilter = CORSFilter()

let requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = [
    (corsFilter, HTTPFilterPriority.high)
]

do {
    let server = HTTPServer()

    server.setRequestFilters(requestFilters)
    server.serverName = "www.example.ca"
    server.serverPort = 8181
    server.addRoutes(routes)

    // Launch the HTTP server.
    try server.start()
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
```

### Configuring CORS

```
import PerfectHTTP
import PerfectHTTPServer
 
// Register your own routes and handlers
var routes = Routes()

// Create CORS filter.
let corsFilter = CORSFilter(origin: ["http://example.com"], methods: [.get, .post])

let requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = [
    (corsFilter, HTTPFilterPriority.high)
]

do {
    let server = HTTPServer()

    server.setRequestFilters(requestFilters)
    server.serverName = "www.example.ca"
    server.serverPort = 8181
    server.addRoutes(routes)

    // Launch the HTTP server.
    try server.start()
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
```

## CORS parameters

You can set custom CORS parameters during creating CORS filter. Below there is description of all parameters.

| Property       | Type                       | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
|----------------|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| origin         | [String]?                  | List of allowed origins. Configures the values returned in Access-Control-Allow-Origin header ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin)). If list is empty all origins are allowed.                                                                                                                                                                                                               |
| methods        | [HTTPMethod]?              | List of allowed HTTP methods. Configures the values returned in Access-Control-Allow-Methods header ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Methods)). If list is empty methods: `GET`, `POST`, `PUT`, `DELETE`, `PATCH` are allowed.                                                                                                                                                                   |
| allowedHeaders | [HTTPRequestHeader.Name]?  | List of allowed HTTP headers. Configures the values returned in Access-Control-Allow-Headers header ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Headers)). If list is empty all headers from request are allowed.                                                                                                                                                                                           |
| exposedHeaders | [HTTPResponseHeader.Name]? | List of exposed HTTP headers. Configures the values returned in Access-Control-Expose-Headers header ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Expose-Headers)). If list is empty no custom headers are exposed.                                                                                                                                                                                                |
| maxAge         | Double?                    | Information about CORS cache. Configures the value returned in Access-Control-Max-Age header. Indicates how long,the results of a preflight request (that is the information contained in the Access-Control-Allow-Methods and Access-Control-Allow-Headers headers) can be cached ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Expose-Headers)). If is not specified header is omitted.                           |
| credentials    | Bool?                      | Information about exposing credentials header. Configures the value returned in Access-Control-Allow-Credentials. The Access-Control-Allow-Credentials response header indicates whether or not the,response to the request can be exposed to the page. It can be exposed when the true value is returned ([more information](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials)). If is not specified header is omitted. |

## License

This project is licensed under the terms of the MIT license.