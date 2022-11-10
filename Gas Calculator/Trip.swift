//
//  Trip.swift
//  Gas Calculator
//
//  Created by Jin on 2022-11-08.
//
import Foundation

class Trip {
    var origin: String
    
    var destination: String
    
    private var gasAmount: Measurement<UnitVolume>?
    
    var gasAmountInLiters: Double = 0 {
        didSet {
            gasAmount = Measurement(value: gasAmountInLiters, unit: .liters)
        }
    }
    
    var gasAmountInGallons: Double {
        get {
            if let gasAmount = gasAmount {
                return gasAmount.converted(to: .gallons).value
            } else {
                return 0
            }
        }
    }
        
    init(origin: String, destination: String) {
        self.origin = origin
        self.destination = destination
    }
}
