//
//  ViewController.swift
//  KeyboardHandling
//
//  Created by Cameron Rivera on 2/5/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logoCenterYConstraint: NSLayoutConstraint!
    
    private var originalConstant: CGFloat = 0.0
    private var keyboardHasShifted: Bool = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        deregisterForKeyboardNotifications()
    }
}

extension ViewController {
    
    private func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func deregisterForKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification){
        guard let keyboardRect = notification.userInfo?["UIKeyboardFrameBeginUserInfoKey"] as? CGRect else {
            return
        }
        shiftKeyboardUp(keyboardRect.height)
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification){
        shiftKeyboardDown()
    }
    
    private func shiftKeyboardUp(_ height: CGFloat){
        if keyboardHasShifted { return }
        originalConstant = logoCenterYConstraint.constant
        logoCenterYConstraint.constant -= height
        keyboardHasShifted = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func shiftKeyboardDown(){
        if !keyboardHasShifted { return }
        logoCenterYConstraint.constant = originalConstant
        keyboardHasShifted = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
