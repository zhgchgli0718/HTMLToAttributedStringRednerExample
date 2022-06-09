//
//  SpanTagRender.swift
//  nsattributedstringTest
//
//  Created by zhgchgli on 2021/12/3.
//

import Foundation

struct SpanTagParser: HTMLTagParser {
    // <span></span>
    static let tag: String = "span"
    var storedHTMLAttributes: [String: String]? = nil
    var style: AttributedStringStyle? = DefaultTextStyle()
}
