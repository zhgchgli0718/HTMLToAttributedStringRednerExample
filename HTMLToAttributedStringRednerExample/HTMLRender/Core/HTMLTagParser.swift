//
//  HTMLTagParser.swift
//
//
//  Created by Harry Li on 2022/5/16.
//

import Foundation

protocol HTMLTagParser {
    static var tag: String { get } // 宣告想解析的 Tag Name, e.g. a
    var storedHTMLAttributes: [String: String]? { get set } // Attributed 解析結果將存放於此, e.g. href,style
    var style: AttributedStringStyle? { get } // 此 Tag 想套用的樣式
    
    func render(attributedString: inout NSMutableAttributedString) // 實現渲染 HTML to attributedString 的邏輯
}

