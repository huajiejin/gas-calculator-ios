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
    
    var gasAmountInGallons: Double = 0 {
        didSet {
            gasAmount = Measurement(value: gasAmountInGallons, unit: .gallons)
        }
    }
    
    var gasAmountInLiters: Double {
        get {
            if let gasAmount = gasAmount {
                return gasAmount.converted(to: .liters).value
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
