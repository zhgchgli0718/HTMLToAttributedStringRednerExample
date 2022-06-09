//
//  AttributedStringStyle.swift
//
//
//  Created by Harry Li on 2022/5/16.
//

import Foundation
import UIKit

protocol AttributedStringStyle {
    var font: UIFont? { get set }
    var color: UIColor? { get set }
    var backgroundColor: UIColor? { get set }
    var wordSpacing: CGFloat? { get set }
    var paragraphStyle: NSParagraphStyle? { get set }
    var customs: [NSAttributedString.Key: Any]? { get set } // 萬能設定口，建議確定可支援規格後將其抽象出來，並關閉此開口
    func render(attributedString: inout NSMutableAttributedString)
}
