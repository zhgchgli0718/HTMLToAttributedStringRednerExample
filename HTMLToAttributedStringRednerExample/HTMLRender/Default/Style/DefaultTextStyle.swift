//
//  DefaultStyle.swift
//
//
//  Created by Harry Li on 2022/5/30.
//

import Foundation
import UIKit

 struct DefaultTextStyle: AttributedStringStyle {
    var font: UIFont? = UIFont.systemFont(ofSize: 14)
    var color: UIColor? = UIColor.black
    var backgroundColor: UIColor? = nil
    var wordSpacing: CGFloat? = nil
    var paragraphStyle: NSParagraphStyle?
    var customs: [NSAttributedString.Key: Any]?
    
    init() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        self.paragraphStyle = paragraphStyle
    }
}
