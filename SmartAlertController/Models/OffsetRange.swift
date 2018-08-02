//
//  File.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 31.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

public struct OffsetRange {
    
    var min: CGFloat?
    var max: CGFloat?
    
    init(min: CGFloat, max: CGFloat? = nil) {
        self.min = min
    }
    
    init(max: CGFloat) {
        self.max = max
    }
    
    func inRange(value: CGFloat) -> Bool {
        var moreThanMin = true
        var lessThanMax = true
        if let min = min {
            moreThanMin = value >= min
        }
        if let max = max {
            lessThanMax = value <= max
        }
        return moreThanMin && lessThanMax
    }
    
}
