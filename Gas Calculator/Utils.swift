//
//  Utils.swift
//  Gas Calculator
//
//  Created by Jin on 2022-11-08.
//

import Foundation

class Utils {
    static let numberFormatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
}
