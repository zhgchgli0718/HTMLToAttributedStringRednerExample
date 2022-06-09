//
//  AttributedStringStyle+Extension.swift
//  nsattributedstringTest
//
//  Created by zhgchgli on 2021/12/3.
//

import UIKit

extension AttributedStringStyle {
    func render(attributedString: inout NSMutableAttributedString) {
        let range = NSMakeRange(0, attributedString.length)
        if let font = font {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }
        if let color = color {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        if let backgroundColor = backgroundColor {
            attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: backgroundColor, range: range)
        }
        if let wordSpacing = wordSpacing {
            attributedString.addAttribute(NSAttributedString.Key.kern, value: wordSpacing as Any, range: range)
        }
        if let paragraphStyle = paragraphStyle {
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        }
        if let customAttributes = customs {
            attributedString.addAttributes(customAttributes, range: range)
        }
    }
}
