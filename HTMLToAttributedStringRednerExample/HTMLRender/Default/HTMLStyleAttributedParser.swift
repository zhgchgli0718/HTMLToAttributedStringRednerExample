//
//  HTMLStyleAttributedRender.swift
//  nsattributedstringTest
//
//  Created by zhgchgli on 2021/12/3.
//

import UIKit

// only support tag attributed down below
// can set color,font seize,line height,word spacing,background color

enum HTMLStyleAttributedParser: String {
    case color = "color"
    case fontSize = "font-size"
    case lineHeight = "line-height"
    case wordSpacing = "word-spacing"
    case backgroundColor = "background-color"
    
    func render(attributedString: inout NSMutableAttributedString, value: String) -> Bool {
        let range = NSMakeRange(0, attributedString.length)
        switch self {
        case .color:
            if let color = convertToiOSColor(value) {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                return true
            }
        case .backgroundColor:
            if let color = convertToiOSColor(value) {
                attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
                return true
            }
        case .fontSize:
            if let size = convertToiOSSize(value) {
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: CGFloat(size)), range: range)
                return true
            }
        case .lineHeight:
            if let size = convertToiOSSize(value) {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = size
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
                return true
            }
        case .wordSpacing:
            if let size = convertToiOSSize(value) {
                attributedString.addAttribute(NSAttributedString.Key.kern, value: size, range: range)
                return true
            }
        }
        
        return false
    }
    
    // convert 36px -> 36
    private func convertToiOSSize(_ string: String) -> CGFloat? {
        guard let regex = try? NSRegularExpression(pattern: "^([0-9]+)"),
              let firstMatch = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)),
              let range = Range(firstMatch.range, in: string),
              let size = Float(String(string[range])) else {
            return nil
        }
        return CGFloat(size)
    }
    
    // convert html hex color #ffffff to UIKit Color
    private func convertToiOSColor(_ hexString: String) -> UIColor? {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return nil
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
