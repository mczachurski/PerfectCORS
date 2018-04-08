// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PerfectCORS",
    products: [
        .library(name: "PerfectCORS", targets: ["PerfectCORS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTP.git", from: "3.0.12")
    ],
    targets: [
        .target(name: "PerfectCORS", dependencies: ["PerfectHTTP"]),
        .testTarget(name: "PerfectCORSTests", dependencies: ["PerfectCORS", "PerfectHTTP"]),
    ]
)
