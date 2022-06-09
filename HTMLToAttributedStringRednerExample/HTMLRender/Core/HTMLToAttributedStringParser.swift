//
//  HTMLToAttributedStringParser.swift
//  nsattributedstringTest
//
//  Created by zhgchgli on 2021/12/2.
//

import Foundation
import UIKit

// Ref: https://github.com/malcommac/SwiftRichString
final class HTMLToAttributedStringParser: NSObject {
    
    private static let topTag = "source"
    private var xmlParser: XMLParser?
    
    private(set) var attributedString: NSMutableAttributedString = NSMutableAttributedString()
    private(set) var supportedTagRenders: [HTMLTagParser] = []
    private let defaultStyle: AttributedStringStyle
    
    /// Styles applied at each fragment.
    private var renderingTagRenders: [HTMLTagParser] = []

    // The XML parser sometimes splits strings, which can break localization-sensitive
    // string transforms. Work around this by using the currentString variable to
    // accumulate partial strings, and then reading them back out as a single string
    // when the current element ends, or when a new one is started.
    private var currentString: String?
    
    // MARK: - Initialization

    init(defaultStyle: AttributedStringStyle) {
        self.defaultStyle = defaultStyle
        super.init()
    }
    
    func register(_ tagRender: HTMLTagParser) {
        if let index = supportedTagRenders.firstIndex(where: { type(of: $0).tag == type(of: tagRender).tag }) {
            supportedTagRenders.remove(at: index)
        }
        supportedTagRenders.append(tagRender)
    }
    
    /// Parse and generate attributed string.
    func parse(string: String) throws -> NSAttributedString {
        var xmlString = HTMLToAttributedStringParser.escapeWithUnicodeEntities(string)
        
        // make sure <br/> format is correct XML
        // because Web may use <br> to present <br/>, but <br> is not a vaild XML
        xmlString = xmlString.replacingOccurrences(of: "<br>", with: "<br/>")
        
        let xml = "<\(HTMLToAttributedStringParser.topTag)>\(xmlString)</\(HTMLToAttributedStringParser.topTag)>"
        guard let data = xml.data(using: String.Encoding.utf8) else {
            throw XMLParserInitError("Unable to convert to UTF8")
        }
        
        let xmlParser = XMLParser(data: data)
        xmlParser.shouldProcessNamespaces = false
        xmlParser.shouldReportNamespacePrefixes = false
        xmlParser.shouldResolveExternalEntities = false
        xmlParser.delegate = self
        self.xmlParser = xmlParser
        
        attributedString = NSMutableAttributedString()
        
        guard xmlParser.parse() else {
            let line = xmlParser.lineNumber
            let shiftColumn = (line == 1)
            let shiftSize = HTMLToAttributedStringParser.topTag.lengthOfBytes(using: String.Encoding.utf8) + 2
            let column = xmlParser.columnNumber - (shiftColumn ? shiftSize : 0)
            
            throw XMLParserError(parserError: xmlParser.parserError, line: line, column: column)
        }
        
        return attributedString
    }
}

// MARK: Private Method

private extension HTMLToAttributedStringParser {
    func enter(element elementName: String, attributes: [String: String]) {
        // elementName = tagName, EX: a,span,div...
        guard elementName != HTMLToAttributedStringParser.topTag else {
            return
        }
        
        if let index = supportedTagRenders.firstIndex(where: { type(of: $0).tag == elementName }) {
            var tagRender = supportedTagRenders[index]
            tagRender.storedHTMLAttributes = attributes
            renderingTagRenders.append(tagRender)
        }
    }
    
    func exit(element elementName: String) {
        if !renderingTagRenders.isEmpty {
            renderingTagRenders.removeLast()
        }
    }
    
    func foundNewString() {
        if let currentString = currentString {
            // currentString != nil ,ex: <i>currentString</i>
            var newAttributedString = NSMutableAttributedString(string: currentString)
            if !renderingTagRenders.isEmpty {
                for (key, tagRender) in renderingTagRenders.enumerated() {
                    // Render Style
                    tagRender.render(attributedString: &newAttributedString)
                    renderingTagRenders[key].storedHTMLAttributes = nil
                }
            } else {
                defaultStyle.render(attributedString: &newAttributedString)
            }
            attributedString.append(newAttributedString)
            self.currentString = nil
        } else {
            // currentString == nil ,ex: <br/>
            var newAttributedString = NSMutableAttributedString()
            for (key, tagRender) in renderingTagRenders.enumerated() {
                // Render Style
                tagRender.render(attributedString: &newAttributedString)
                renderingTagRenders[key].storedHTMLAttributes = nil
            }
            attributedString.append(newAttributedString)
        }
    }
}

// MARK: Helper

extension HTMLToAttributedStringParser {
    // handle html entity / html hex
    // Perform string escaping to replace all characters which is not supported by NSXMLParser
    // into the specified encoding with decimal entity.
    // For example if your string contains '&' character parser will break the style.
    // This option is active by default.
    // ref: https://github.com/malcommac/SwiftRichString/blob/e0b72d5c96968d7802856d2be096202c9798e8d1/Sources/SwiftRichString/Support/XMLStringBuilder.swift
    static func escapeWithUnicodeEntities(_ string: String) -> String {
        guard let escapeAmpRegExp = try? NSRegularExpression(pattern: "&(?!(#[0-9]{2,4}|[A-z]{2,6});)", options: NSRegularExpression.Options(rawValue: 0)) else {
            return string
        }
        
        let range = NSRange(location: 0, length: string.count)
        return escapeAmpRegExp.stringByReplacingMatches(in: string,
                                                        options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                        range: range,
                                                        withTemplate: "&amp;")
    }
}

// MARK: XMLParserDelegate

extension HTMLToAttributedStringParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        foundNewString()
        enter(element: elementName, attributes: attributeDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        foundNewString()
        guard elementName != HTMLToAttributedStringParser.topTag else {
            return
        }
        
        exit(element: elementName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString = (currentString ?? "").appending(string)
    }
}
