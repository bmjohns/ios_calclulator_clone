//
//  NumberOutputLabel.swift
//  CalculatorRemake
//
//  Created by Brett M Johnsen on 1/11/18.
//  Copyright © 2018 Brett M Johnsen. All rights reserved.
//

import Foundation
import UIKit



/// Custom label that formats the text of the label so that it is user friendly and consumable for computation
final class NumberOutputLabel: UILabel {
    
    private let maximumCount = 11
    private let startingFontSize:CGFloat = 90 // default 90 to fit iphone7/8 size devices best
    
    
    /// Number formatter with scientific style
    static var scientificFormatter:NumberFormatter {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .scientific
        numberFormatter.positiveFormat = "0E0"
        numberFormatter.exponentSymbol = "e"
        return numberFormatter
    }
    
    
    /// Number formatter with decimal style
    static var decimalFormatter:NumberFormatter {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 7
        
        return numberFormatter
    }
    
    override var text: String? {
        didSet {
            // depending on text size decrease font so that more characters fit on the screen
            if let text = text {
                if text.count > maximumCount {
                    font = UIFont.systemFont(ofSize: startingFontSize - 35, weight: .thin)
                } else if text.count == maximumCount { // TODO: Make this based on text fitting, not count
                    font = UIFont.systemFont(ofSize: startingFontSize - 30, weight: .thin)
                } else if text.count >= 9 {
                    font = UIFont.systemFont(ofSize: startingFontSize - 25, weight: .thin)
                } else if text.count >= 8 {
                    font = UIFont.systemFont(ofSize: startingFontSize - 15, weight: .thin)
                } else {
                    font = UIFont.systemFont(ofSize: startingFontSize, weight: .thin)
                }
            }
        }
    }
    
    /// Double value of the text in the label
    var numberRaw: Double? {
        var number: Double?
        if let text = text {
            number = Double(stripCommas(fromString:text))
        }
        return number
    }
    
    /// String of the double value representation of text in the label. This excludes parenthesis
    var stringRaw: String {
        
        var string = ""
        if let numberRaw = numberRaw {
            string = "\(numberRaw)"
        }
        return string
    }
    
    
    /// Value that should be set when a calculated soltion needs to be presented to the user
    /// It will have parenthesis and if to long convert to scientific method
    var calculatedValue:String = "0" {
        didSet {
            formatAndSetTextIfAppropriate(withString: calculatedValue,
                                          isUserEntry: false)
        }
    }
    
    /// Value that when set will display a user friendly interpretation of a number to the user
    /// It will have parenthesis and limit the amount of text allowed to be entered
    var userEnteredValue:String = "0" {
        didSet {
            formatAndSetTextIfAppropriate(withString: userEnteredValue,
                                          isUserEntry: true)
        }
    }
    
    
    /// Set the text with the appropriate format
    /// User entry should limit the amount of numbers added, and always be in decimal format
    /// Calculated solutions should be changed to scientific format if over a set limit
    ///
    /// - Parameters:
    ///   - string: String to be formated and set
    ///   - isUserEntry: Bool true if user entered the number, false if it was calculated
    private func formatAndSetTextIfAppropriate(withString string: String, isUserEntry:Bool) {
        
        // first get the number from the text so we can re-format  and calculate the amount as needed
        if let number = NumberOutputLabel.decimalFormatter.number(from: stripCommas(fromString:string)) {
            if (number.doubleValue > 999999999 || number.doubleValue < -999999999) && !isUserEntry {
                // numbers a million or more will not fit easily on screen, so switch for scientific if we calculated the solution
                setTextForScientific(fromNumber: number)
            } else {
                setTextForDecmalIfAppropriate(fromNumber: number)
            }
        }
    }
    
    
    /// Conditionally sets the text for scientific format
    ///
    /// - Parameter number: NSNumber that should be set in scientific format
    private func setTextForScientific(fromNumber number: NSNumber) {
        
        if let scientificValue = NumberOutputLabel.scientificFormatter.string(from: number) {
            let formattedString = scientificValue
            text = formattedString
        }
    }
    
    
    /// Conditionally sets the text for decimal format
    ///
    /// - Parameter number: NSNumber that should be set in decimal format
    private func setTextForDecmalIfAppropriate(fromNumber number: NSNumber) {
        
        if let decimalString = NumberOutputLabel.decimalFormatter.string(from: number),
            decimalString.count <= maximumCount
                || (decimalString.contains("-") && decimalString.count == maximumCount + 1) { // if changing to a negative, allow one more character
            var formattedString = decimalString
            // we don't want to show decimal when value is 0
            if decimalString == "0.0" {
                formattedString = "0"
            }
            text = formattedString
        }
    }
    
    /// Strips commas from a string
    ///
    /// - Parameter string: String that contains commas
    /// - Returns: String with removed commas
    private func stripCommas(fromString string: String) -> String {
        
        var strippedString = ""
        
        strippedString = string.components(separatedBy: ",").joined()
        
        return strippedString
    }
}
