//
//  StringAdditions.swift
//
//
//  Created by Guillaume Bourachot on 29/10/2019.
//

import Foundation
#if canImport(UIKit)
import UIKit

extension StringProtocol where Index == String.Index {

    /// This method returns the lowerBound of the index of the searched string into another string. If the string is not found, the result is nil
    /// - Parameters:
    ///   - string: The searched string
    ///   - options: The searching options, like case sensitive, etc ...
    public func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }


    /// This method returns the upperBound of the index of the searched string into another string. If the string is not found, the result is nil
    /// - Parameters:
    ///   - string: The searched string
    ///   - options: The searching options, like case sensitive, etc ...
    public func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }


    /// This method returns the indexes the searched string into another string. If the string is not found, the result is an empty arrayl
    /// - Parameters:
    ///   - string: The searched string
    ///   - options: The searching options, like case sensitive, etc ...
    public func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range.lowerBound)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }

    /// This method returns the ranges of the searched string into another string. If the string is not found, the result is an empty arrayl
    /// - Parameters:
    ///   - string: The searched string
    ///   - options: The searching options, like case sensitive, etc ...
    public func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while start < endIndex,
            let range = self[start..<endIndex].range(of: string, options: options) {
                result.append(range)
                start = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension String {
    
    /// This method returns the NSRange from the start of the current string  to the searched string or throws an error if the searched string is not found
    /// - Parameter endOfString: The searched string
    public func rangeFromStart(upTo endOfString: String) throws -> NSRange {
        guard let endIndex = self.endIndex(of: endOfString) else {
                fatalError("Could not retrieve endIndex.")
        }

        return NSRange(location: 0, length: self.distance(from: self.startIndex, to: endIndex))
    }

    /// This method returns the NSRange from to the searched string to the end of the current string or throws an error if the searched string is not found
    /// - Parameter endOfString: The searched string
    public func rangeUntilEnd(from endOfString: String) throws -> NSRange {
        guard let endIndex = self.endIndex(of: endOfString) else {
                fatalError("Could not retrieve endIndex.")
        }

        let startingLocation = self.distance(from: self.startIndex, to: endIndex)
        return NSRange(location: startingLocation, length: self.count - startingLocation)
    }
}

extension String {
    private func boldInterpretation(_ plainText: inout String, _ result: inout NSMutableAttributedString) {
        if let indexStartOpeningOfBold = plainText.index(of: "<b>"),
           let indexEndClosingOfBold = plainText.endIndex(of: "</b>"){
            
            if indexEndClosingOfBold < indexStartOpeningOfBold {
                if let range = plainText.range(of: "</b>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "</b>", with: "", options: .caseInsensitive, range: plainText.startIndex..<indexEndClosingOfBold)
                }
            } else {
                
                let subString = plainText[indexStartOpeningOfBold..<indexEndClosingOfBold]
                if let range = plainText.range(of: subString) {
                    let nsRange = NSRange.init(range, in: plainText)
                    result.addAttributes([.font: UIFont.boldSystemFont(ofSize: 18)], range: nsRange)
                }
                if let range = plainText.range(of: "<b>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "<b>", with: "", options: .caseInsensitive, range: indexStartOpeningOfBold..<indexEndClosingOfBold)
                }
                if let range = plainText.range(of: "</b>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "</b>", with: "", options: .caseInsensitive, range: indexStartOpeningOfBold..<indexEndClosingOfBold)
                }
            }
        }
    }
    
    private func underlineInterpretation(_ plainText: inout String, _ result: inout NSMutableAttributedString) {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        if let indexStartOpeningOfU = plainText.index(of: "<u>"),
           let indexEndClosingOfU = plainText.endIndex(of: "</u>"){
            
            if indexEndClosingOfU < indexStartOpeningOfU {
                if let range = plainText.range(of: "</u>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "</u>", with: "", options: .caseInsensitive, range: plainText.startIndex..<indexEndClosingOfU)
                }
            } else {
                
                let subString = plainText[indexStartOpeningOfU..<indexEndClosingOfU]
                if let range = plainText.range(of: subString) {
                    let nsRange = NSRange.init(range, in: plainText)
                    result.addAttributes(underlineAttribute, range: nsRange)
                }
                if let range = plainText.range(of: "<u>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "<u>", with: "", options: .caseInsensitive, range: indexStartOpeningOfU..<indexEndClosingOfU)
                }
                if let range = plainText.range(of: "</u>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "</u>", with: "", options: .caseInsensitive, range: indexStartOpeningOfU..<indexEndClosingOfU)
                }
            }
        }
    }
    
    private func italicInterpretation(_ plainText: inout String, _ result: inout NSMutableAttributedString) {
        if let indexStartOpeningOfBalise = plainText.index(of: "<i>"),
           let indexEndClosingOfBalise = plainText.endIndex(of: "</i>") {
            
            if indexEndClosingOfBalise < indexStartOpeningOfBalise {
                if let range = plainText.range(of: "</i>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "</i>", with: "", options: .caseInsensitive, range: plainText.startIndex..<indexEndClosingOfBalise)
                }
            } else {
                let subString = plainText[indexStartOpeningOfBalise..<indexEndClosingOfBalise]
                if let range = plainText.range(of: subString) {
                    let nsRange = NSRange.init(range, in: plainText)
                    result.addAttributes([.font: UIFont.italicSystemFont(ofSize: 16)], range: nsRange)
                }
                if let range = plainText.range(of: "<i>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "<i>", with: "", options: .caseInsensitive, range: indexStartOpeningOfBalise..<indexEndClosingOfBalise)
                }
                if let range = plainText.range(of: "</i>")?.nsRange(in: plainText){
                    result.deleteCharacters(in: range)
                    plainText = plainText.replacingOccurrences(of: "</i>", with: "", options: .caseInsensitive, range: indexStartOpeningOfBalise..<indexEndClosingOfBalise)
                }
            }
        }
    }
    
    public func simpleHTMLInterpreted() -> NSMutableAttributedString {
        var result = NSMutableAttributedString()
        var plainText = self
        result.append(.init(string: plainText))
        while(plainText.index(of: "<b>") != nil) {
            self.boldInterpretation(&plainText, &result)
        }
        while(plainText.index(of: "<u>") != nil) {
            self.underlineInterpretation(&plainText, &result)
        }
        while(plainText.index(of: "<i>") != nil) {
            self.italicInterpretation(&plainText, &result)
        }
        return result
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}
#endif
