//
//  String+Helpers.swift
//  AISwiftHelpersExample
//
//  Created by Ahsan Iqbal on 8/5/18.
//  Copyright © 2018 Munfarid Technologies. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /**
     * returns clean String without white spaces
     */
    internal func withoutWhiteSpaces() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /**
     * convert string to date
     */
    internal func toDate(_ pattern: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = pattern
        return dateFormatter.date(from: self)
    }
    
    /**
     * convert String to Bool
     */
    func toBool() -> Bool {
        
        if self == "true" || self == "1" || self == "YES" || self == "TRUE"{
            return true
        }
        else {
            return false
        }
    }
    
    /**
     * convert String to Dictionary
     */
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /**
     * returns the passed time from current date to given date
     * pass the date in yyyy-MM-dd hh:mm:ss format
     */
    internal func timePassedFromDate() -> String {
        let start: Date! = self.toDate("yyyy-MM-dd HH:mm")
        let end: Date! = Date()
        
        var cal = Calendar.current
        cal.locale = Locale(identifier: "en_US")
        
        let unit: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.weekOfMonth, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute]
        let components = (cal as NSCalendar).components(unit, from: start, to: end, options: NSCalendar.Options.matchLast)
        if components.year! > 0 {
            if components.year == 1 {
                return "a year ago"
            }
            return "\(components.year!) years ago"
        } else if components.month! > 0 {
            if components.month == 1 {
                return "a month ago"
            }
            return "\(components.month!) months ago"
        } else if components.weekOfMonth! > 0 {
            if components.weekOfMonth == 1 {
                return "a week ago"
            }
            return "\(components.weekOfMonth!) weeks ago"
        } else if components.day! > 0 {
            if components.day == 1 {
                return "yesterday"
            }
            return "\(components.day!) days ago"
        } else if components.hour! > 0 {
            if components.hour == 1 {
                return "1 hour ago"
            }
            return "\(components.hour!) hours ago"
        } else {
            return "few minutes ago"
        }
    }
    
    /**
     * returns String after removing Sub-String
     */
    func removeSubString(toBeRemoved: String) -> String {
        return self.replacingOccurrences(of: toBeRemoved, with: "")
    }
    
    /**
     * returns String after removing array of Sub-Strings
     */
    func stringByRemovingAll(subStrings: [String]) -> String {
        var resultString = self
        let _ = subStrings.map { resultString = resultString.replacingOccurrences(of: $0, with: "") }
        return resultString
    }
    
    /**
     * returns NSMutableAttributedString with colored partial text
     */
    func attributedStringForPartiallyColoredText(_ textToFind: String, with color: UIColor) -> NSMutableAttributedString {
        let mutableAttributedstring = NSMutableAttributedString(string: self)
        let range = mutableAttributedstring.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            mutableAttributedstring.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        }
        return mutableAttributedstring
    }
    
    /**
     * returns count of Sub-String found within a String
     */
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var searchRange: Range<String.Index>?
        var count = 0
        while let foundRange = range(of: stringToFind, options: .diacriticInsensitive, range: searchRange) {
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
            count += 1
        }
        return count
    }
    
    /**
     * returns height needed for dynamic text using text view's width and font size
     */
    func textHeight (forWidth width: CGFloat, font: UIFont) -> CGFloat {
        let attributedText = NSAttributedString(string: self, attributes: [NSAttributedStringKey.font:font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
    
    /**
     * checks if String is valid Email Id or not
     */
    func isEmail() -> Bool {
        let emailRegex: String = "^([^@\\s]+)@((?:[-a-z0-9]+\\.)+[a-z]{2,})$"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [emailRegex])
        return emailTest.evaluate(with: self.withoutWhiteSpaces())
    }
}
