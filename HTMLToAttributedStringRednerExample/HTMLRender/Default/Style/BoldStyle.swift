//
//  BoldStyle.swift
//  HTMLToAttributedStringRednerExample
//
//  Created by ZhgChgLi on 2022/6/9.
//

import Foundation
import UIKit

struct BoldStyle: AttributedStringStyle {
   var font: UIFont? = UIFont.systemFont(ofSize: 14, weight: .bold)
   var color: UIColor? = UIColor.black
   var backgroundColor: UIColor? = nil
   var wordSpacing: CGFloat? = nil
   var paragraphStyle: NSParagraphStyle?
   var customs: [NSAttributedString.Key: Any]? = [.underlineStyle: NSUnderlineStyle.single.rawValue]
}
