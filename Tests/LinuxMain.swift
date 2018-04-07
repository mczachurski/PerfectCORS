import XCTest
@testable import PerfectCORSTests

XCTMain([
    testCase(CORSFilterTests.allTests),
    testCase(AllowCredentialsTests.allTests),
    testCase(AllowHeadersTests.allTests),
    testCase(AllowMethodsTests.allTests),
    testCase(AllowOriginTests.allTests),
    testCase(ExposeHeadersTests.allTests),
    testCase(MaxAgeTests.allTests)
])
