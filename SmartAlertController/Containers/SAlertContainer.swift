//
//  SAlertContainer.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 16.06.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

enum AlertState {
    case beforeAppearence
    case appeared
    case dismissed
}

class SAlertContainer: UIView {
    
    var animationsDuration: Double = 0.2
    
    var alertView: SmartAlertView!
    var layoutCalculator: LayoutCalculator!
    var configuration: SConfiguration!
    
    var state: AlertState = .beforeAppearence
    
    var availableSize: CGSize?

    init(alertView: SmartAlertView,
         configuration: SConfiguration,
         layoutCalculator: LayoutCalculator) {
        super.init(frame: .zero)
        addSubview(alertView)
        self.alertView = alertView
        self.configuration = configuration
        self.layoutCalculator = layoutCalculator
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func layout(animated: Bool) {
        guard let availableSize = availableSize else { return }
        let frame = layoutCalculator.frame(forState: state,
                                           forConfiguration: configuration,
                                           availableSize: availableSize)
        
        let animation = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.frame = frame
            strongSelf.alertView.frame = strongSelf.bounds
        }
        
        if animated {
            UIView.animate(withDuration: animationsDuration,
                           animations: animation)
        }else{
            animation()
        }
    }
    
}

extension SAlertContainer: Appearable {
    
    func appear(animated: Bool) {        
        let appearenceAnimation = configuration.appearenceAnimation ?? .none
        
        self.layout(animated: false)
        state = .appeared
        self.layout(animated: animated)
        if appearenceAnimation == .fade && animated  {
            alertView.alpha = 0
            UIView.animate(withDuration: animationsDuration) {
                self.alpha = 1
            }
        }
    }
    
    func dismiss() {
        guard let availableSize = availableSize
            else { return }
        
        let appearenceAnimation = configuration.appearenceAnimation ?? .none
        let endFrame: CGRect = layoutCalculator.endFrame(forConfiguration: configuration, availableSize: availableSize)
        self.frame = endFrame
        self.alertView.alpha = appearenceAnimation == .none ? 1 : 0
    }
    
    func dismissAnimated(completion: @escaping () -> ()) {
        guard let availableSize = availableSize
            else { return }
        
        let appearenceAnimation = configuration.appearenceAnimation ?? .none
        let endFrame: CGRect = layoutCalculator.endFrame(forConfiguration: configuration, availableSize: availableSize)
        
        UIView.animate(withDuration: animationsDuration,
                       animations: {
                        self.frame = endFrame
                        self.alertView.alpha = appearenceAnimation == .none ? 1 : 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
}
