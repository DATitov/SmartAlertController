//
//  KeyboardObserver.swift
//  SmartAlertController
//
//  Created by Виолетта Веселкова on 05.08.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

typealias KayboardFrameChangedAction = (CGRect, TimeInterval, UIViewAnimationOptions?) -> Void

class KeyboardObserver {

    var keyboardFrameWillChange: KayboardFrameChangedAction?
    
    init() {
        initBindings()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Bindings
    
    private func initBindings() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardObserver.keyboardFrameWillChange(notification:)),
                                               name: Notification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        
    }
    
    @objc private func keyboardFrameWillChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let endFrame = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect,
            let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval
            else {
                return
        }
        let options: UIViewAnimationOptions? = { number in
            guard let number = number else {
                return nil
            }
            let intVal = number.intValue
            return UIViewAnimationOptions(rawValue: UInt(intVal << 16))
        }(userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)
        
        if let action = keyboardFrameWillChange {
            action(endFrame, duration, options)
        }
    }
    
}
