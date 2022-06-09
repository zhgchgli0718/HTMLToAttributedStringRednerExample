//
//  HTMLTagParser+DefaultExtension.swift
//
//
//  Created by Harry Li on 2022/5/16.
//

import Foundation

extension HTMLTagParser {

    func render(attributedString: inout NSMutableAttributedString) {
        defaultStyleRender(attributedString: &attributedString)
    }
    
    func defaultStyleRender(attributedString: inout NSMutableAttributedString) {
        // setup default style to NSMutableAttributedString
        style?.render(attributedString: &attributedString)
        
        // setup & override HTML style (style="color:red;background-color:black") to NSMutableAttributedString if is exists
        // any html tag can have style attribute
        if let style = storedHTMLAttributes?["style"] {
            let styles = style.split(separator: ";").map { $0.split(separator: ":") }.filter { $0.count == 2 }
            for style in styles {
                let key = String(style[0])
                let value = String(style[1])
                
                if let styleAttributed = HTMLStyleAttributedParser(rawValue: key), styleAttributed.render(attributedString: &attributedString, value: value) {
                    print("Unsupport style attributed or value[\(key):\(value)]")
                }
            }
        }
    }
}
