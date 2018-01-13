//
//  CalculationHandler.swift
//  CalculatorRemake
//
//  Created by Brett M Johnsen on 1/10/18.
//  Copyright © 2018 Brett M Johnsen. All rights reserved.
//

import Foundation


/// Handles storing and calculating operations. To calculate store a double in firstEntry, secondEntry, and call the calculateOperationIfNecessary or calculateUtilityOperation.
///
/// Example: [firstEntry] [operation] [secondEntry] = [solution]
///               6            +           3        =     6
///
struct CalculationHandler {
    
    
    /// Will be the first number included in the operation
    static var firstEntry:Double?
    /// Will be the second number included in the operation
    static var secondEntry: Double?
    /// Operation that is next to be executed
    static var currentOperation: Operation?
    
    
    /// Calculate operation if one is already stored, otherwise store it for later
    ///
    /// - Parameter operation: Operation to be stored
    /// - Returns: Double of the calculated solution
    static func calculateOperationIfNecessary(operation:Operation) -> Double? {
        
        var calculatedValue: Double?
        
        if let _ = currentOperation {
            calculatedValue = calculate()
        }
        currentOperation = operation
        return calculatedValue
    }

    /// Perform necessary actions for the utility operation(clear, equals)
    ///
    /// - Parameters:
    ///   - operation: UtilityOperation to be performed
    ///   - number: number that will be used to calculate
    /// - Returns: Double of the calculated solution, nil if no solution provided
    static func calculateUtilityOperation(operation:UtilityOperation, withNumber number:Double?) -> Double? {
        
        var calculatedValue: Double?
        switch operation {
        case .clear:
            clear()
            calculatedValue = 0
        case .equals:
            calculatedValue = calculate()
        case .percent:
            if let number = number {
                calculatedValue = percent(ofDouble: number)
            }
        case .positiveNegative:
            if let number = number {
                calculatedValue = changePositiveNegativeStatus(ofDouble: number)
            }
        }
        return calculatedValue
    }
    
    
    /// Conditionally stores in first entry, if first entry already stored, we store in second entry.
    ///
    /// - Parameter number: Double of number to be stored
    static func storeNumberForCalculation(number:Double) {
        
        if firstEntry == nil {
            firstEntry = number
        } else {
            secondEntry = number
        }
    }
    
    
    /// Calculates the current setup operation with the first and second entry
    ///
    /// - Returns: Double of the calculated solution
    private static func calculate() -> Double {
        
        var solution = 0.0
        
        if let operation = currentOperation {
            switch operation {
            case .addition:
                solution = add()
            case .subtract:
                solution = subtract()
            case .multiply:
                solution = multiply()
            case .divide:
                solution = divide()
            }
        }
        
        return solution
    }
    
    
    /// Adds the first entry to the last entry
    ///
    /// - Returns: Double of the two added numbers
    private static func add() -> Double {
        
        var solution = 0.0
        // calculate the addition
        if let secondEntry = secondEntry,
            let firstEntry = firstEntry {
            solution = firstEntry + secondEntry
        }
        return solution
    }
    
    /// Subtracts the first entry from the last entry
    ///
    /// - Returns: Double of the two subtracted numbers
    private static func subtract() -> Double {
        
        var solution = 0.0
        // calculate the addition
        if let secondEntry = secondEntry,
            let firstEntry = firstEntry {
            solution = firstEntry - secondEntry
        }
        return solution
    }
    
    /// Multiplies the first entry from the last entry
    ///
    /// - Returns: Double of the two multiplied numbers
    private static func multiply() -> Double {
        
        var solution = 0.0
        // calculate the addition
        if let secondEntry = secondEntry,
            let firstEntry = firstEntry {
            solution = firstEntry * secondEntry
        }
        return solution
    }
    
    /// Divides the first entry from the last entry
    ///
    /// - Returns: Double of the two divided numbers
    private static func divide() -> Double {
        
        var solution = 0.0
        // calculate the addition
        if let secondEntry = secondEntry,
            let firstEntry = firstEntry {
            solution = firstEntry / secondEntry
        }
        return solution
    }
    
    /// Give the percent value of the second entry
    ///
    /// - Returns: Percent number
    private static func percent(ofDouble double: Double) -> Double {
        
        var solution = 0.0
        solution = double * 0.01
        
        return solution
    }
    
    /// Clear the stored user entries
    private static func clear() {
        
        firstEntry = nil
        secondEntry = nil
        currentOperation = nil
    }
    
    /// Switch the negative/postive value
    ///
    /// - Parameter double: Double to be switched
    /// - Returns: New number
    private static func changePositiveNegativeStatus(ofDouble double:Double) -> Double {
        
        let changedDouble = double * -1
        return changedDouble
    }
}
