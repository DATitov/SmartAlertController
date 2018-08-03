//
//  SBackgroundView.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 21.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

public enum SBackgroundViewType {
    case defaultView
    case custom(view: UIView?)
}

final class SBackgroundView: UIView {
    
    var animationsDuration: Double = 0.2
    
    private var backgroundView: UIView?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
//        backgroundColor = UIColor.blue
        change(backgrounType: .defaultView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView?.frame = bounds
    }
    
    func change(backgrounType type: SBackgroundViewType) {
        backgroundView?.removeFromSuperview()
        switch type {
        case .defaultView:
            backgroundView = defaultBV()
        case .custom(let view):
            guard let view = view else {
                backgroundView = defaultBV()
                break
            }
            backgroundView = view
        }
        if let backgroundView = backgroundView {
            addSubview(backgroundView)
        }
        setNeedsLayout()
    }
    
    private func defaultBV() -> UIView {
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }
    
}

extension SBackgroundView: Appearable {
    
    func appear(animated: Bool) {
        backgroundView?.alpha = 0
        let animation = { [weak self] in
            self?.backgroundView?.alpha = 0.5
        }
        if animated {
            UIView.animate(withDuration: animationsDuration,
                           animations: {
                            animation()
            })
        }else{
            animation()
        }
    }
    
    func dismiss() {
        backgroundView?.alpha = 0
    }
    
    func dismissAnimated(completion: @escaping () -> ()) {
        UIView.animate(withDuration: animationsDuration,
                       animations: {
                        self.backgroundView?.alpha = 0
        })
    }
    
}
