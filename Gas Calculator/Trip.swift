//
//  Trip.swift
//  Gas Calculator
//
//  Created by Jin on 2022-11-08.
//
import Foundation

class Trip: NSObject, NSCoding {
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
    
    required init(coder: NSCoder) {
        origin = coder.decodeObject(forKey: "origin") as! String
        destination = coder.decodeObject(forKey: "destination") as! String
        if let gasAmountInGallonsValue = coder.decodeObject(forKey: "gasAmountInGallons") as! String? {
            gasAmountInGallons = Double(gasAmountInGallonsValue) ?? 0
            gasAmount = Measurement(value: gasAmountInGallons, unit: .gallons)
        }
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(origin, forKey: "origin")
        coder.encode(destination, forKey: "destination")
        coder.encode("\(gasAmountInGallons)", forKey: "gasAmountInGallons")
    }
}
