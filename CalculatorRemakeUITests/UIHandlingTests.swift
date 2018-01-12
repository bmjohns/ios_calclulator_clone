//
//  UIHandlingTests.swift
//  CalculatorRemakeUITests
//
//  Created by Brett M Johnsen on 1/10/18.
//  Copyright © 2018 Brett M Johnsen. All rights reserved.
//

import XCTest

/// Handles testing UI specific handlings of the app. Like button states and number limiting.
class UIHandlingTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Makes sure the user entered value is limited to the correct number of characters
    func testMaxNumber() {
        
        let app = XCUIApplication()
        
        let button = app.buttons["9"]
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        button.tap()
        
        XCTAssert(app.staticTexts["999,999,999"].exists)
    }

    /// Test that clear is working correctly
    func testClear() {
        
        let app = XCUIApplication()
        app.buttons["8"].tap()
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["3"].tap()
        
        app.buttons["AC"].tap()
        XCTAssert(app.staticTexts["0"].exists)
    }
    
    /// Makes sure that the button states are properly changing and removing
    func testStates() {
        
        var isStatesProper = false
        let app = XCUIApplication()
        let button = app.buttons["÷"]
        button.tap()
        button.tap()
        if button.isSelected {
            isStatesProper = true
        }
        
        let button2 = app.buttons["×"]
        button2.tap()
        button2.tap()
        if button2.isSelected
        && button.isSelected == false {
            isStatesProper = true
        }

        let button3 = app.buttons["−"]
        button3.tap()
        button3.tap()
        if button3.isSelected
            && button.isSelected == false
            && button2.isSelected == false{
            isStatesProper = true
        }

        
        let button4 = app.buttons["+"]
        button4.tap()
        button4.tap()
        if button4.isSelected
            && button.isSelected == false
            && button2.isSelected == false
            && button3.isSelected == false {
            isStatesProper = true
        }

        
        let button5 = app.buttons["="]
        app.buttons["AC"].tap()
        
        if button5.isSelected == false
            && button.isSelected == false
            && button2.isSelected == false
            && button3.isSelected == false
            && button4.isSelected == false {
            isStatesProper = true
        }
        XCTAssert(isStatesProper)
    }
    
}
