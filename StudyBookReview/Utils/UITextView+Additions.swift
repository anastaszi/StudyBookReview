//
//  UITextView+Additions.swift
//  StudyBookReviews
//
//  Created by Anastasia Zimina on 3/20/21.
//
//
//  Created by Kaikai Liu on 1/31/21.
// For UITextView there is no Done button to dismiss the keyboard like UITextField. UITextView is having a return button on the keyboard for the new line. The keyboard return button is used for the new line
//The best way is to add a done button over the keyboard to dismiss it.
//ref: https://www.swiftdevcenter.com/uitextview-dismiss-keyboard-swift/

//import Foundation


import UIKit

private var borders = [UITextView: Bool]()

extension UITextView {
    
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//Create a UIBarButtonItem of type flexibleSpace
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//Create UIBarButtonItem using parameter title, target and action
        toolBar.setItems([flexible, barButton], animated: false)//Assign this two UIBarButtonItem to toolBar
        self.inputAccessoryView = toolBar//Set this toolBar as inputAccessoryView to the UITextView
    }
    
}

