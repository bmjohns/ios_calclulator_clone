//
//  ViewController.swift
//  CalculatorRemake
//
//  Created by Brett M Johnsen on 1/10/18.
//  Copyright © 2018 Brett M Johnsen. All rights reserved.
//

import UIKit


/// View Controller that controls the buttons and labels on the main calculator page.
class MainCalculatorViewController: UIViewController {
    
    
    // MARK: Properties
    
    /// NumberOutputLabel that displays the output text to the user
    @IBOutlet var entryLabel: NumberOutputLabel!
    /// NSLayoutConstraint that controls the width of all the calculator buttons
    @IBOutlet var calculatorButtonWidthConstraint: NSLayoutConstraint!
    /// Bool true if clearing, false if not
    var isClearingOnNumberPress = false
    /// Current selected calculator button, applies only to + / - *
    var currentSingleSelectButton:CalculatorButton?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    
    /// User pressed the clear button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressClear(_ sender: CalculatorButton) {
        
        selectNewButton(nil)
       handleUtilityOperation(.clear, withNumber: entryLabel.numberRaw)
    }
    
    /// User pressed the positive/negative button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressPositiveNegative(_ sender: CalculatorButton) {
        
        handleUtilityOperation(.positiveNegative, withNumber: entryLabel.numberRaw)
    }
    
    /// User pressed the percent button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressPercent(_ sender: CalculatorButton) {
        
        handleUtilityOperation(.percent, withNumber: entryLabel.numberRaw)
    }
    
    /// User pressed the divide button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressDivide(_ sender: CalculatorButton) {
        
        handleOperation(.divide, fromButton: sender)
    }
    
    /// User pressed the multiply button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressMultiply(_ sender: CalculatorButton) {
        
        handleOperation(.multiply, fromButton: sender)
    }
    
    /// User pressed the subtract button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressSubtract(_ sender: CalculatorButton) {
        
        handleOperation(.subtract, fromButton: sender)
    }
    
    /// User pressed the addition button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressAddition(_ sender: CalculatorButton) {
        
        handleOperation(.addition, fromButton: sender)
    }
    
    /// User pressed the addition button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressDecimal(_ sender: CalculatorButton) {
        
        selectNewButton(nil)
        
        if let numberString = sender.titleLabel?.text {
            if let entryLabelText = entryLabel.text {
                entryLabel.text = entryLabelText + numberString
            } else {
                entryLabel.text = numberString
            }
        }
    }
    
    /// User pressed the number or decimal button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressNumber(_ sender: CalculatorButton) {
        
        selectNewButton(nil)
        
        if isClearingOnNumberPress {
            entryLabel.text = ""
            isClearingOnNumberPress = false
        }
        if let numberString = sender.titleLabel?.text {
            if let entryLabelText = entryLabel.text,
                entryLabelText != "0" {
                entryLabel.userEnteredValue = entryLabelText + numberString
            } else {
                entryLabel.userEnteredValue = numberString
            }
        }
    }
    
    /// User pressed the equals button.
    ///
    /// - Parameter sender: CalculatorButton that was pressed
    @IBAction func didPressEquals(_ sender: CalculatorButton) {
        selectNewButton(nil)
        if !isClearingOnNumberPress || CalculationHandler.secondEntry == nil {
            CalculationHandler.secondEntry = entryLabel.numberRaw
        } else {
            CalculationHandler.firstEntry = entryLabel.numberRaw
        }
        
        if let value = CalculationHandler.calculateUtilityOperation(operation: .equals,
                                                                    withNumber :nil) {
            entryLabel.calculatedValue = "\(value)"
            CalculationHandler.firstEntry = value
        }
        isClearingOnNumberPress = true
    }
    
    
    /// Handles utility operations like clear, equals, percent, and negative.
    ///
    /// - Parameters:
    ///   - utilityOperation: UtilityOperation to be performed
    ///   - number: Number to be calculated. Not needed for equals and clear
    func handleUtilityOperation(_ utilityOperation: UtilityOperation, withNumber number: Double?) {
        
        if let calculatedNumber = CalculationHandler.calculateUtilityOperation(operation: utilityOperation,
                                                                               withNumber: number) {
            entryLabel.calculatedValue = "\(calculatedNumber)"
            
            switch utilityOperation {
            case .percent, .positiveNegative:
                // overwite saved entry if already saved to properly handle next operation
                if CalculationHandler.firstEntry != nil {
                    CalculationHandler.firstEntry = calculatedNumber
                }
            default:
                // other take no action
                break
            }
        }
    }
    
    /// Handles the selection of a new Operation. involves changing the selection state of the button and making any calculations if necessary.
    ///
    /// - Parameters:
    ///   - operation: Operation type that was selected.
    ///   - button: CalculatorButton that was selected
    private func handleOperation(_ operation:Operation, fromButton button: CalculatorButton) {
        
        // only handle operation if it was not already selected
        if button != currentSingleSelectButton {
            
            if isClearingOnNumberPress {
                CalculationHandler.currentOperation = nil
            }
            
            selectNewButton(button)
            if let number = entryLabel.numberRaw {
                CalculationHandler.storeNumberForCalculation(number: number)
            }
            if let value = CalculationHandler.calculateOperationIfNecessary(operation: operation) {
                entryLabel.calculatedValue = "\(value)"
                CalculationHandler.firstEntry = value
            }
            isClearingOnNumberPress = true
        }
    }
    
    
    /// Sets a new button as selected, and de-selects the old selected button.
    /// This should only apply to the buttons of type Operation.
    ///
    /// - Parameter button: CalculatorButton that should now be selected
    private func selectNewButton(_ button:CalculatorButton?) {
        
        currentSingleSelectButton?.isSelected = false
        currentSingleSelectButton = button
        currentSingleSelectButton?.isSelected = true
    }
    
}

