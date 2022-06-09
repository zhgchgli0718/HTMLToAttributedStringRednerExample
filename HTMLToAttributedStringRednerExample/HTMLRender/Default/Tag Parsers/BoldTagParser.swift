//
//  BoldTagRender.swift
//  nsattributedstringTest
//
//  Created by zhgchgli on 2021/12/3.
//

import Foundation

struct BoldTagParser: HTMLTagParser {
    // <b></b>
    static let tag: String = "b"
    var storedHTMLAttributes: [String: String]? = nil
    let style: AttributedStringStyle? = BoldStyle()
}
