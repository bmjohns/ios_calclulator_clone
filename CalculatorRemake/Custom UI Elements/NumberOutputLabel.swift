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
        numberFormatter.maximumFractionDigits = 8
        
        return numberFormatter
    }
    
    override var text: String? {
        didSet {
            // depending on text size decrease font so that more characters fit on the screen
            if let text = text {
                if text.count >= 12 { // TODO: Make this based on text fitting, not count
                    font = UIFont.systemFont(ofSize: startingFontSize - 38, weight: .thin)
                } else if text.count == 11 {
                    font = UIFont.systemFont(ofSize: startingFontSize - 33, weight: .thin)
                } else if text.count == 10 {
                    font = UIFont.systemFont(ofSize: startingFontSize - 28, weight: .thin)
                } else if text.count == 9 {
                    font = UIFont.systemFont(ofSize: startingFontSize - 18, weight: .thin)
                } else if text.count == 8 {
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
                setTextForDecmalIfAppropriate(fromNumberString: string,
                                              isUserEntry: isUserEntry)
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
    
    
    /// Conditionally sets the text for decimal format
    ///
    /// - Parameters:
    ///   - numberString: String that should be set in decimal format
    ///   - isUserEntry: Bool true if this was user entered text. False if being set programmatically by calculation
    private func setTextForDecmalIfAppropriate(fromNumberString numberString:String, isUserEntry: Bool) {
        
        let strippedNumberString = stripCommas(fromString: numberString)
        let numberFormatter = adjustedDecimalFormatter(forNumber: strippedNumberString)
        var number = numberFormatter.number(from: strippedNumberString)
        
        if !isUserEntry && number?.doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
            // if we have a whole number, then do not show .0
            numberFormatter.maximumFractionDigits = 0
            number = numberFormatter.number(from: strippedNumberString)
        }
        if let decimalNumber = number,
            let decimalString = numberFormatter.string(from: decimalNumber),
            !isUserEntry || (isUserEntry && numberString.count <= maximumCharacterCount(forNumberString: numberString)) { // we stop user from entering more characters conditionally
            text = decimalString
        }
    }
    
    
    /// Maxmimum character count depends on the type of number we have. We allow more characters if , or - is present
    ///
    /// - Parameter number: Number that is being used to decide if we have hit maxmimum character count or not
    /// - Returns: Int
    private func maximumCharacterCount(forNumberString number:String) -> Int {
        
        let maximumCount: Int
        
        if number.contains("-") {
            maximumCount = 12
        } else if number.contains(",") {
            maximumCount = 11
        } else {
            maximumCount = 10
        }
        return maximumCount
    }
    
    
    /// Adjusts the decimal formatter maxmimum fraction digits allowed based on how many whole numbers are present
    ///
    /// - Parameter number: Number that could contain fraction digits
    /// - Returns: Number formatter with adjusted maximumFractionDigits
    private func adjustedDecimalFormatter(forNumber number:String) -> NumberFormatter {
        
        let numberFormatter = NumberOutputLabel.decimalFormatter
        
        let decimalSplitNumber = number.components(separatedBy: ".")
        if decimalSplitNumber.count > 1,
            let wholeNumber = decimalSplitNumber.first,
            wholeNumber.count > 1 {
            numberFormatter.maximumFractionDigits = numberFormatter.maximumFractionDigits - wholeNumber.count
        }
        return numberFormatter
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
