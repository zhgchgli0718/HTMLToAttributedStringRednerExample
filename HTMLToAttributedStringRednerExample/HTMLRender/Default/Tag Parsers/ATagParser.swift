//
//  ATagRender.swift
//  nsattributedstringTest
//
//  Created by zhgchgli on 2021/12/3.
//

import Foundation

struct ATagParser: HTMLTagParser {
    // <a></a>
    static let tag: String = "a"
    var storedHTMLAttributes: [String: String]? = nil
    let style: AttributedStringStyle? = LinkStyle()
    
    func render(attributedString: inout NSMutableAttributedString) {
        defaultStyleRender(attributedString: &attributedString)
        if let href = storedHTMLAttributes?["href"], let url = URL(string: href) {
            let range = NSMakeRange(0, attributedString.length)
            attributedString.addAttribute(NSAttributedString.Key.link, value: url, range: range)
        }
    }
}
