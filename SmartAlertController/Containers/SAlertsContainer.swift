//
//  SmartAlertsContainer.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 21.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class SAlertsContainer: UIView {
    
    var animator: SAnimator!
    
    var appeared = false
    var acceptableHorisontalScrollOffset: OffsetRange?
    var acceptableVerticalScrollOffset: OffsetRange?
    var keyboardVisibleHeight: CGFloat?
    
    var animationsDuration: Double = 0.2 {
        didSet {
            self.alertContainers.forEach({
                $0.animationsDuration = animationsDuration
            })
        }
    }

    var alertContainers = [SAlertContainer]()
    
    private var tapGR = UITapGestureRecognizer()
    
    var backgroundPressed: (() -> ())?
    var notAcceptableOffsetReached: (() -> ())?
    
    fileprivate let layoutCalculator = LayoutCalculator()
    
    let scrollView = UIScrollView()

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    func setupUI() {
        addSubview(scrollView)
        addGestureRecognizer(tapGR)
        tapGR.addTarget(self, action: #selector(SAlertsContainer.backgroundTapped))
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: scrollView)
        guard let action = backgroundPressed,
            alertContainers.filter({ $0.frame.contains(tapPoint) }).count < 1
            else { return }
        action()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout(animated: false, completion: {  })
    }
    
    fileprivate func layout(animated: Bool, completion: @escaping () -> ()) {
        let availableSize = frame.size
        alertContainers.forEach({
            $0.availableSize = availableSize
        })
        let animation = { [weak self] in
            guard let strSelf = self else { return }
            strSelf.baseLayout()
            strSelf.alertContainers.forEach({
                $0.layout(animated: false)
            })
        }
        if animated {
            UIView.animate(withDuration: animationsDuration,
                           animations: {
                            animation()
            }) { _ in
                completion()
            }
        }else{
            animation()
            completion()
        }
    }
    
    fileprivate func baseLayout() {
        let scrollViewFrame = CGRect(x: 0, y: 0,
                                        width: frame.size.width,
                                        height: frame.size.height - (keyboardVisibleHeight ?? 0.0))
        scrollView.frame = scrollViewFrame
        let requiredHeight = alertContainers
            .map({ $0.configuration })
            .map { [weak self] (conf) -> CGFloat in
                guard let strSelf = self else {
                    return 0
                }
                return strSelf.layoutCalculator.requiredHeight(forConfiguration: conf!,
                                                               viewHeight: scrollViewFrame.size.height)
            }
            .max() ?? frame.size.height + 1
        let contentSize = CGSize(width: scrollViewFrame.size.width,
                                 height: max(requiredHeight, scrollViewFrame.size.height + 1))
        scrollView.contentSize = contentSize
        alertContainers.forEach({
            $0.availableSize = contentSize
        })
    }
    
    func layoutOnKeyboardVisibleHeightChanged(duration: TimeInterval, options: UIViewAnimationOptions?) {
        let animation: () -> Void = { [weak self] in
            self?.baseLayout()
            self?.alertContainers.forEach({
                $0.layout(animated: false)
            })
        }
        if let options = options {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: options,
                           animations: animation,
                           completion: nil)
        }else{
            UIView.animate(withDuration: duration,
                           animations: animation)
        }
    }
    
    // MARK: Helpers
    
    fileprivate func container(forAlert alert: UIView) -> SAlertContainer? {
        return alertContainers.filter({ $0.alertView.isEqual(alert) }).first
    }
    
}

extension SAlertsContainer: SManagedAlertViewContainer {
    
    func add(alertView alert: UIView, configuration: SConfiguration) {
        let container = SAlertContainer(alertView: alert,
                                        configuration: configuration,
                                        layoutCalculator: layoutCalculator)
        container.animationsDuration = animationsDuration
        alertContainers.append(container)
        scrollView.addSubview(container)
        container.setNeedsLayout()
        container.availableSize = frame.size
        if appeared {
            container.appear(animated: true)
        }
    }
    
    func remove(alertView alert: UIView) {
        guard let container = container(forAlert: alert),
            let index = alertContainers.index(of: container)
            else { return }
        
        alertContainers.remove(at: index)
        container.dismissAnimated {
            container.removeFromSuperview()
        }
    }
    
    func removeAllAlerts() {
        alertContainers.forEach({ $0.removeFromSuperview() })
        alertContainers = [SAlertContainer]()
    }
    
    func update(alertView alert: UIView) {
        guard let container = container(forAlert: alert) else { return }
        baseLayout()
        container.layout(animated: true)
    }
    
    func updateAllAlertViews() {
        alertContainers.forEach({
            $0.layout(animated: true)
        })
    }
    
    func set(configuration: SConfiguration, toAlertView alert: UIView) {
        guard let container = container(forAlert: alert) else { return }
        container.configuration = configuration
        container.layout(animated: true)
    }
    
}

extension SAlertsContainer: Appearable {
    
    func appear(animated: Bool) {
        layout(animated: false, completion: {  })
        alertContainers.forEach({
            $0.appear(animated: animated)
        })
    }
    
    func dismiss() {
        alertContainers.forEach({
            $0.dismiss()
        })
    }
    
}

extension SAlertsContainer: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset = scrollView.contentOffset
        if let range = acceptableHorisontalScrollOffset, !range.inRange(value: offset.x) {
            notAcceptableOffsetReached?()
        }
        if offset.y > 0 &&
            offset.y <= scrollView.contentSize.height - scrollView.frame.size.height {
            return
        }else if offset.y > 0 {
            offset.y -= scrollView.contentSize.height - scrollView.frame.size.height
        }
        if let range = acceptableVerticalScrollOffset, !range.inRange(value: offset.y) {
            notAcceptableOffsetReached?()
        }
    }
    
}
