//
//  HTMLStripper.swift
//  PinkoiFoundation
//
//  Created by zhgchgli on 2021/12/27.
//  Copyright © 2021 Pinkoi. All rights reserved.
//

import Foundation

// Ref: https://github.com/malcommac/SwiftRichString
final class HTMLStripper: NSObject, XMLParserDelegate {

    private static let topTag = "source"
    private var xmlParser: XMLParser
    
    private(set) var storedString: String
    
    // The XML parser sometimes splits strings, which can break localization-sensitive
    // string transforms. Work around this by using the currentString variable to
    // accumulate partial strings, and then reading them back out as a single string
    // when the current element ends, or when a new one is started.
    private var currentString: String?
    
    // MARK: - Initialization

    init(string: String) throws {
        let xmlString = HTMLStripper.escapeWithUnicodeEntities(string)
        let xml = "<\(HTMLStripper.topTag)>\(xmlString)</\(HTMLStripper.topTag)>"
        guard let data = xml.data(using: String.Encoding.utf8) else {
            throw XMLParserInitError("Unable to convert to UTF8")
        }
        
        self.xmlParser = XMLParser(data: data)
        self.storedString = ""
        
        super.init()
        
        xmlParser.shouldProcessNamespaces = false
        xmlParser.shouldReportNamespacePrefixes = false
        xmlParser.shouldResolveExternalEntities = false
        xmlParser.delegate = self
    }
    
    /// Parse and generate attributed string.
    func parse() throws -> String {
        guard xmlParser.parse() else {
            let line = xmlParser.lineNumber
            let shiftColumn = (line == 1)
            let shiftSize = HTMLStripper.topTag.lengthOfBytes(using: String.Encoding.utf8) + 2
            let column = xmlParser.columnNumber - (shiftColumn ? shiftSize : 0)
            
            throw XMLParserError(parserError: xmlParser.parserError, line: line, column: column)
        }
        
        return storedString
    }
    
    // MARK: XMLParserDelegate
    
    @objc func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        foundNewString()
    }
    
    @objc func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        foundNewString()
    }
    
    @objc func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString = (currentString ?? "").appending(string)
    }
    
    // MARK: Support Private Methods
    
    func foundNewString() {
        if let currentString = currentString {
            storedString.append(currentString)
            self.currentString = nil
        }
    }
    
    // handle html entity / html hex
    // Perform string escaping to replace all characters which is not supported by NSXMLParser
    // into the specified encoding with decimal entity.
    // For example if your string contains '&' character parser will break the style.
    // This option is active by default.
    // ref: https://github.com/malcommac/SwiftRichString/blob/e0b72d5c96968d7802856d2be096202c9798e8d1/Sources/SwiftRichString/Support/XMLStringBuilder.swift
    fileprivate static func escapeWithUnicodeEntities(_ string: String) -> String {
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
