//
//  KeyboardObservingView.swift
//  SmartAlertControllerDemo
//
//  Created by Виолетта Веселкова on 04.08.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class KeyboardObservingView: UIView {
    
    var manager: SAlertManager? {
        didSet {
            if let manager = manager {
                bind(manager: manager)
            }
        }
    }
    var conf: SConfiguration?

    let titleLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    var allowPasswordEntry = false
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    func setupUI() {
        for view in [titleLabel, emailTextField, passwordTextField] {
            addSubview(view)
        }
        titleLabel.text = "Keyboard appearence test"
        
        [emailTextField, passwordTextField].forEach({ [weak self] in
            $0.borderStyle = .roundedRect
            $0.delegate = self
        })
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        
        passwordTextField.isSecureTextEntry = true
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
    }
    
    func bind(manager: SAlertManager) {
        manager.backgroundPressed = { [weak self] in
            guard let strSelf = self else { return }
            if let firstResponder =  [strSelf.emailTextField, strSelf.passwordTextField].filter({ $0.isFirstResponder }).first {
                firstResponder.resignFirstResponder()
            }else{
                strSelf.manager?.dismiss()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horOffset: CGFloat = 22.0
        let vertOffset: CGFloat = 15.0
        
        let height: CGFloat = 30
        let width = frame.size.width - 2.0 * horOffset
        titleLabel.frame = CGRect(x: horOffset, y: vertOffset,
                                  width: width, height: height)
        
        if allowPasswordEntry {
            emailTextField.frame = CGRect(x: horOffset,
                                          y: frame.size.height - 2.0 * (vertOffset + height),
                                             width: width,
                                             height: height)
            passwordTextField.frame = CGRect(x: horOffset,
                                             y: frame.size.height - vertOffset - height,
                                             width: width,
                                             height: height)
        }else{
            emailTextField.frame = CGRect(x: horOffset, y: frame.size.height - vertOffset - height,
                                          width: width,
                                          height: height)
        }
    }
    
}

extension KeyboardObservingView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            if allowPasswordEntry {
                passwordTextField.becomeFirstResponder()
            }else{
                if let conf = conf, let height = conf.viewHeight {
                    conf.viewHeight = height + 45.0
                }
                if var heigh = conf?.viewHeight {
                    heigh += CGFloat(45.0)
                }
                allowPasswordEntry = true
                manager?.update(alertView: self)
                passwordTextField.alpha = 0
                UIView.animate(withDuration: 0.2) {
                    self.passwordTextField.alpha = 1
                }
            }
            return true
        case 1:
            return true
        default:
            return true
        }
    }
    
}
