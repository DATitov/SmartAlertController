//
//  LayoutCalculator.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 16.06.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class LayoutCalculator {

    fileprivate let defaultOffset: CGFloat = 30.0
    
    func frame(forState state: AlertState, forConfiguration conf: SConfiguration, availableSize: CGSize) -> CGRect {
        switch state {
        case .beforeAppearence:
            return startFrame(forConfiguration: conf, availableSize: availableSize)
        case .appeared:
            return frame(forConfiguration: conf, availableSize: availableSize)
        case .dismissed:
            return endFrame(forConfiguration: conf, availableSize: availableSize)
        }
    }
    
    func frame(forConfiguration conf: SConfiguration, availableSize: CGSize) -> CGRect {
        guard !__CGSizeEqualToSize(CGSize.zero, availableSize) else {
            return CGRect.zero
        }
        let width = self.width(forConfiguration: conf, availableSize: availableSize)
        let height = self.height(forConfiguration: conf, availableSize: availableSize)
        let x = self.x(forConfiguration: conf, availableSize: availableSize, width: width)
        let y = self.y(forConfiguration: conf, availableSize: availableSize, height: height)
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func startFrame(forConfiguration conf: SConfiguration, availableSize: CGSize) -> CGRect {
        let alertFrame = frame(forConfiguration: conf, availableSize: availableSize)
        var x = alertFrame.origin.x
        var y = alertFrame.origin.y
        switch conf.appearenceDirection {
        case .top:
            y = -alertFrame.size.height
        case .bottom:
            y = availableSize.height
        case .left:
            x = -alertFrame.size.width
        case .right:
            x = availableSize.width
        }
        return CGRect(origin: CGPoint(x: x, y: y),
                      size: alertFrame.size)
    }
    
    func endFrame(forConfiguration conf: SConfiguration, availableSize: CGSize) -> CGRect {
        let alertFrame = frame(forConfiguration: conf, availableSize: availableSize)
        var x = alertFrame.origin.x
        var y = alertFrame.origin.y
        switch conf.dismissDirection ?? conf.appearenceDirection {
        case .top:
            y = -alertFrame.size.height
        case .bottom:
            y = availableSize.height
        case .left:
            x = -alertFrame.size.width
        case .right:
            x = availableSize.width
        }
        return CGRect(origin: CGPoint(x: x, y: y),
                      size: alertFrame.size)
    }
    
    func width(forConfiguration conf: SConfiguration, availableSize: CGSize) -> CGFloat {
        if let width = conf.viewWidth {
            return width
        }else if let leadOffset = conf.leadingOffset,
            let trailOffset = conf.trailingOffset {
            return availableSize.width - leadOffset - trailOffset
        }else if let leadOffset = conf.leadingOffset {
            return availableSize.width - 2.0 * leadOffset
        }else if let trailOffset = conf.trailingOffset {
            return availableSize.width - 2.0 * trailOffset
        }
        return 0.0
    }
    
    func height(forConfiguration conf: SConfiguration, availableSize: CGSize) -> CGFloat {
        if let height = conf.viewHeight {
            return height
        }else if let topOffset = conf.topOffset,
            let bottOffset = conf.bottomOffset {
            return availableSize.height - topOffset - bottOffset
        }else if let topOffset = conf.topOffset {
            return availableSize.height - 2.0 * topOffset
        }else if let bottOffset = conf.bottomOffset {
            return availableSize.height - 2.0 * bottOffset
        }
        return 0.0
    }
    
    func x(forConfiguration conf: SConfiguration, availableSize: CGSize, width: CGFloat) -> CGFloat {
        switch conf.horisontalBinding {
        case .left:
            return conf.leadingOffset ?? 20.0
        case .center:
            return (availableSize.width - width) / 2.0
        case .right:
            return availableSize.width - (conf.trailingOffset ?? 20.0) - width
        case .allSpace:
            return conf.leadingOffset ?? 20.0
        }
    }
    
    func y(forConfiguration conf: SConfiguration, availableSize: CGSize, height: CGFloat) -> CGFloat {
        switch conf.verticalBinding {
        case .top:
            return conf.topOffset ?? 20.0
        case .center:
            return (availableSize.height - height) / 2.0
        case .bottom:
            return availableSize.height - (conf.bottomOffset ?? 20.0) - height
        }
    }
    
}
