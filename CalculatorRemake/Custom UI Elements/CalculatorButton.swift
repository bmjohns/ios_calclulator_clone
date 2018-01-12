//
//  CalculatorButton.swift
//  CalculatorRemake
//
//  Created by Brett M Johnsen on 1/10/18.
//  Copyright © 2018 Brett M Johnsen. All rights reserved.
//

import Foundation
import UIKit

// Custom UI for displaying calcultor buttons in storyboards/nibs.
@IBDesignable class CalculatorButton: UIButton {
    
    /// Corner radius number that will be divided by the width. Used to make the buttomn have rounded corners.
    @IBInspectable var cornerRadiusDivision: CGFloat = 2.0 {
        didSet {
            applyRoundedMask()
        }
    }
    
    /// Set the background color while the button is any state but selected
    @IBInspectable var defaultBackgroundColor: UIColor? {
        didSet {
            if let color = defaultBackgroundColor {
                backgroundColor = color
            }
        }
    }
    /// Set the background color while the button is in selected state
    @IBInspectable var selectedBackgroundColor: UIColor?
    
    // When set true button will become a circle. Button should have equal width and height for true circle to show.
    @IBInspectable var isCircular: Bool = false {
        didSet {
            if isCircular {
                applyRoundedMask()
            }
        }
    }
    
    open override var isSelected: Bool {
        willSet {
            // do nothing, but willSet needed to avoid compile error
        }
        
        didSet {
            
            // Update the color based on selection
            let backgroundColor = isSelected ? selectedBackgroundColor : defaultBackgroundColor
            if let backgroundColor = backgroundColor {
                self.backgroundColor = backgroundColor
            }
        }
    }
    
    func setBackgroundColor(color: UIColor, state: UIControlState) {
        let image = CalculatorButton.image(color: color)
        setBackgroundImage(image, for: state)
    }
    
    fileprivate static func image(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    fileprivate func applyRoundedMask() {
        
        layer.cornerRadius = bounds.size.width / cornerRadiusDivision
        clipsToBounds = true
    }
}
