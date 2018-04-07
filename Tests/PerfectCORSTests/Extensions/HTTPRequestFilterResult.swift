//
//  HTTPRequestFilterResult.swift
//  PerfectCORSTests
//
//  Created by Marcin Czachurski on 07.04.2018.
//

import Foundation
import PerfectHTTP

extension HTTPRequestFilterResult: Equatable {

    static public func == (lhs: HTTPRequestFilterResult, rhs: HTTPRequestFilterResult) -> Bool {
        switch (lhs, rhs) {
        case (.continue, .continue):
            return true
        case (.halt, .halt):
            return true
        case (.execute, .execute):
            return true
        default:
            return false
        }
    }
}
