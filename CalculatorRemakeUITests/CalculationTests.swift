//
//  CalculationTests.swift
//  CalculatorRemakeUITests
//
//  Created by Brett M Johnsen on 1/12/18.
//  Copyright © 2018 Brett M Johnsen. All rights reserved.
//

import XCTest

class CalculationTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
//        let app = XCUIApplication()
//        app.buttons["×"].tap()
//        app.buttons["÷"].tap()
//        app.buttons["%"].tap()
//        app.buttons["+/-"].tap()
//        app.buttons["."].tap()
//        app.buttons["C"].tap()
        
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
    
    func testOrderOfOperations() {
        
        let app = XCUIApplication()
        app.buttons["9"].tap()
        app.buttons["+"].tap()
        let button1 = app.buttons["1"]
        button1.tap()
        app.buttons["×"].tap()
        button1.tap()
        app.buttons["0"].tap()
        app.buttons["="].tap()

        XCTAssert(app.staticTexts["100"].exists)
    }
    
    func testAddition() {

        let app = XCUIApplication()
        let button = app.buttons["6"]
        button.tap()
        
        let button2 = app.buttons["5"]
        button2.tap()
        
        let button3 = app.buttons["+"]
        button3.tap()
        app.buttons["9"].tap()
        
        let button4 = app.buttons["="]
        button4.tap()
        XCTAssert(app.staticTexts["74"].exists)
    }
    
    func testMultipleAdditions() {
        
        
        let app = XCUIApplication()
        let button = app.buttons["1"]
        button.tap()
        
        let button2 = app.buttons["3"]
        button2.tap()
        
        let plusButton = app.buttons["+"]
        plusButton.tap()
        app.buttons["6"].tap()
        plusButton.tap()
        app.buttons["4"].tap()
        plusButton.tap()

        XCTAssert(app.staticTexts["23"].exists)
    }
    
    func testSubtractionWithNegative() {
        
        
        let app = XCUIApplication()
        let button = app.buttons["6"]
        button.tap()
        
        let button3 = app.buttons["−"]
        button3.tap()
        app.buttons["9"].tap()
        
        let button4 = app.buttons["="]
        button4.tap()
        XCTAssert(app.staticTexts["-3"].exists)
    }
    
    func testMultipleSubtractions() {
        
        
        let app = XCUIApplication()
        let button = app.buttons["1"]
        button.tap()
        button.tap()
        
        let subtractButton = app.buttons["−"]
        subtractButton.tap()
        app.buttons["4"].tap()
        subtractButton.tap()
        app.buttons["2"].tap()
        subtractButton.tap()
        
        XCTAssert(app.staticTexts["5"].exists)
    }
    
    func testMultiplication() {
        
        let app = XCUIApplication()
        let button = app.buttons["6"]
        button.tap()
        
        let button3 = app.buttons["×"]
        button3.tap()
        app.buttons["9"].tap()
        
        let button4 = app.buttons["="]
        button4.tap()
        XCTAssert(app.staticTexts["54"].exists)
    }
    
    func testMultipleMultiplications() {
        
        
        let app = XCUIApplication()
        let button = app.buttons["6"]
        button.tap()
        button.tap()
        
        let multiplyButton = app.buttons["×"]
        multiplyButton.tap()
        app.buttons["2"].tap()
        multiplyButton.tap()
        app.buttons["3"].tap()
        multiplyButton.tap()
        
        XCTAssert(app.staticTexts["396"].exists)
    }
    
    func testDivision() {
        
        let app = XCUIApplication()
        let button = app.buttons["6"]
        button.tap()
        
        let button3 = app.buttons["÷"]
        button3.tap()
        app.buttons["3"].tap()
        
        let button4 = app.buttons["="]
        button4.tap()
        XCTAssert(app.staticTexts["2"].exists)
    }
    
    func testMultipleDivision() {
        
        
        let app = XCUIApplication()
        let button1 = app.buttons["1"]
        button1.tap()
        let button0 = app.buttons["0"]
        button0.tap()
        button0.tap()
        
        let divideButton = app.buttons["÷"]
        divideButton.tap()
        app.buttons["2"].tap()
        divideButton.tap()
        button1.tap()
        divideButton.tap()
        app.buttons["4"].tap()
        divideButton.tap()
        
        XCTAssert(app.staticTexts["12.5"].exists)
    }
    
    func testRoundingDecimal() {
        
        
        let app = XCUIApplication()
        let button = app.buttons["1"]
        button.tap()
        button.tap()
        
        app.buttons["÷"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        

        XCTAssert(app.staticTexts["3.66666667"].exists)
    }
    
    func testPercent() {
        
        let app = XCUIApplication()
        let button = app.buttons["1"]
        button.tap()
        button.tap()
        
        app.buttons["%"].tap()
        
        XCTAssert(app.staticTexts["0.11"].exists)
    }
    
    func testNegative() {
        
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
        
        let swapButton = app.buttons["+/-"]
        swapButton.tap()
        XCTAssert(app.staticTexts["-999,999,999"].exists)
        swapButton.tap()
        XCTAssert(app.staticTexts["999,999,999"].exists)
    }
    
    func testScientificNegative() {
        
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
        
        app.buttons["×"].tap()
        app.buttons["2"].tap()
        app.buttons["="].tap()
        app.buttons["+/-"].tap()
        XCTAssert(app.staticTexts["-2e9"].exists)
    }
    
    func testScientificNotation() {
        
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
        
        app.buttons["×"].tap()
        app.buttons["2"].tap()
        let equalButton = app.buttons["="]
        equalButton.tap()
        XCTAssert(app.staticTexts["2e9"].exists)
        app.buttons["÷"].tap()
        app.buttons["3"].tap()
        equalButton.tap()
        
        XCTAssert(app.staticTexts["666,666,666"].exists)
    }
    
    func testMultipleEquals() {
        
        let app = XCUIApplication()
        let button = app.buttons["1"]
        button.tap()
        
        let button2 = app.buttons["0"]
        button2.tap()
        
        let button3 = app.buttons["+"]
        button3.tap()
        app.buttons["2"].tap()
        
        let button4 = app.buttons["="]
        button4.tap()
        button4.tap()
        button4.tap()
        XCTAssert(app.staticTexts["16"].exists)
    }
    
    func testMaxmimumDecimal() {
        
        let app = XCUIApplication()
        let button = app.buttons["9"]
        button.tap()
        app.buttons["."].tap()
         button.tap()
         button.tap()
         button.tap()
         button.tap()
         button.tap()
         button.tap()
         button.tap()
         button.tap()
        app.buttons["5"].tap()
        app.buttons["3"].tap()
        app.buttons["2"].tap()
        XCTAssert(app.staticTexts["9.99999999"].exists)
        
        app.buttons["+/-"].tap()
        XCTAssert(app.staticTexts["-10"].exists)
    }
    
    func testMultipleOperations() {
        
        let app = XCUIApplication()
        app.buttons["3"].tap()
        let plusButton = app.buttons["+"]
        plusButton.tap()
        app.buttons["6"].tap()
        let subtractButton = app.buttons["−"]
        subtractButton.tap()
        let button2 = app.buttons["2"]
        button2.tap()
        app.buttons["×"].tap()
        app.buttons["5"].tap()
        subtractButton.tap()
        let button1 = app.buttons["1"]
        button1.tap()
        let button0 = app.buttons["0"]
        button0.tap()
        button0.tap()
        button0.tap()
        let buttonEquals = app.buttons["="]
        buttonEquals.tap()
        XCTAssert(app.staticTexts["-965"].exists)

        app.buttons["+/-"].tap()
        plusButton.tap()
        button1.tap()
        button0.tap()
        button0.tap()
        buttonEquals.tap()
        
        app.buttons["%"].tap()
        XCTAssert(app.staticTexts["10.65"].exists)
        
        let divideButton = app.buttons["÷"]
        divideButton.tap()
        button2.tap()
        buttonEquals.tap()
        buttonEquals.tap()
        XCTAssert(app.staticTexts["2.6625"].exists)
    }
    
}
