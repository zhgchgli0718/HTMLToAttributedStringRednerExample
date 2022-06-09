//
//  Error.swift
//  HTMLToAttributedStringRednerExample
//
//  Created by ZhgChgLi on 2022/6/9.
//

import Foundation

struct XMLParserInitError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var localizedDescription: String {
        return message
    }
}

struct XMLParserError: Error {
    let parserError: Error?
    let line: Int
    let column: Int
}
