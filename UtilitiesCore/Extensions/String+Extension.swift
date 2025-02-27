//
//  String.swift
//  UtilitiesCore
//
//  Created by Gabriel Miranda Silveira on 16/11/18.
//  Copyright © 2018 4all. All rights reserved.
//

import Foundation

public extension String {
    /// Returns a String removing all whitespaces, not only the leading/trailing but also in the middle of the string
    var removingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }

    /// Returns a String removing the leading/trailing whitespaces and new lines
    var trimmingWhitespacesAndNewLines: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Transform String date from one format to another
    ///
    /// - Parameters:
    ///   - receivingFormat: actual string date format
    ///   - transforming: new date format
    /// - Returns: String with the new format or nil if fail
    func transformDateFormat(_ receivingFormat: String, new transforming: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = receivingFormat
        let date = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = transforming
        
        guard let unDate = date else { return nil }
        let stringFormatted = dateFormatter.string(from: unDate)
        
        return stringFormatted
    }
}

public extension String {
    /// Returns a String containing only numbers or an empty String
    var numbersOnly: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    /// Verify if the string has one or more numbers
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// Verify if the string has only numbers
    var hasOnlyNumbers: Bool {
        return rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    /// Returns a String containing only letters or an empty String
    var lettersOnly: String {
        return components(separatedBy: CharacterSet.letters.inverted).joined()
    }

    /// Verify if the string has one or more letters
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }

    /// Verify if the string has only letters
    var hasOnlyLetters: Bool {
        return rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }

    /// Verify if the string contains at least one letter and one number
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
}

public extension String {
    /// Dictionary from string JSON format
    var toDictionary: [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                return nil
            }
        }
        return nil
    }
}

public extension String {
    /// Get number if string is brazilian currency or return nil
    var brazilianCurrencyNumber: NSNumber? {
        let formatter = NumberFormatter.brazilianCurrencyFormatter

        guard let value = formatter.number(from: self) else {
            return nil
        }
        return value
    }

    /// Transform string in html format to NSAttributedString with the layout of html
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }


    /// Create a substring based on the range passed
    ///
    /// - Parameter range: range to create the substring
    subscript (range: Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[startIndex..<endIndex])
    }

    subscript(range: CountableClosedRange<Int>) -> Substring {
        return self[index(at: range.lowerBound)...index(at: range.upperBound)]
    }

    subscript(range: PartialRangeUpTo<Int>) -> Substring {
        return self[..<index(at: range.upperBound)]
    }

    subscript(range: PartialRangeThrough<Int>) -> Substring {
        return self[...index(at: range.upperBound)]
    }

    subscript(range: PartialRangeFrom<Int>) -> Substring {
        return self[index(at: range.lowerBound)...]
    }

    internal func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}
