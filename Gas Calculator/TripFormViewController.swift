//
//  TripFormViewController.swift
//  Gas Calculator
//
//  Created by Jin on 2022-11-10.
//

import UIKit

class TripFormViewController: UIViewController {
    @IBOutlet var originTextField: UITextField!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var gasAmountTextField: UITextField!
    
    var trip: Trip = Trip(origin: "", destination: "")
    var isAddingNewTrip: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originTextField.text = trip.origin
        destinationTextField.text = trip.destination
        if trip.gasAmountInGallons > 0 {
            gasAmountTextField.text = "\(trip.gasAmountInGallons)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.trip.origin = originTextField.text ?? ""
        self.trip.destination = destinationTextField.text ?? ""
        self.trip.gasAmountInGallons = Double((gasAmountTextField.text ?? "").replacingOccurrences(of: NSLocale.current.decimalSeparator! as String, with: ".")) ?? 0
    }
}
