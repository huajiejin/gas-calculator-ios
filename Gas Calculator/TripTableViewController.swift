//
//  TripTableViewController.swift
//  Gas Calculator
//
//  Created by Jin on 2022-11-08.
//

import UIKit

class TripTableViewController: UIViewController {
    
    @IBOutlet weak var tripTableView: UITableView!
    
    var tripStore = TripStore()
    var trips: [Trip] {
        set {
            tripStore.trips = newValue
        }
        get {
            return tripStore.trips
        }
    }
    
    required init?(coder aDcoder: NSCoder) {
        super.init(coder: aDcoder)
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.addTrip(_:)))
    }
    
    @objc func addTrip(_ sender: UIBarButtonItem) {
        let trip = Trip(origin: "", destination: "")
        trips.append(trip)
        tripTableView.insertRows(at: [IndexPath(row: trips.count - 1, section: 0)], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToTripForm":
            if let row = tripTableView.indexPathForSelectedRow?.row {
                let tripFormViewController = segue.destination as! TripFormViewController
                tripFormViewController.trip = trips[row]
            }
        default:
            preconditionFailure("Segue indentifier \(String(describing: segue.identifier)) does not exists")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tripTableView.dataSource = self
        tripTableView.delegate = self
        tripTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tripTableView.reloadData()
        updateTitle()
    }
    
    func updateTitle() {
        var totalGasAmountInLiters: Double = 0
        for trip in trips {
            totalGasAmountInLiters = totalGasAmountInLiters + trip.gasAmountInLiters
        }
        navigationItem.title = "Total \(Utils.numberFormatter.string(from: NSNumber(value: totalGasAmountInLiters)) ?? "0")L"
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tripTableView.setEditing(editing, animated: animated)
        updateTitle()
    }
}

extension TripTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // only create cells displayed on the screen by using dequeueReusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripCell
        let trip = trips[indexPath.row]
        cell.originLabel.text = trip.origin
        cell.destinationLabel.text = trip.destination
        if let gasAmountInLitersText = Utils.numberFormatter.string(from: NSNumber(value: trip.gasAmountInLiters)){
            cell.gasAmountLabel.text = "\(gasAmountInLitersText)(L)"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
}

extension TripTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row != destinationIndexPath.row {
            let movedTrip = trips[sourceIndexPath.row]
            trips.remove(at: sourceIndexPath.row)
            trips.insert(movedTrip, at: destinationIndexPath.row)
        }
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteText = NSLocalizedString("Confirm Delete", comment: "Delete trip")
            let deleteMessageText = NSLocalizedString("Delete this Trip?", comment: "Delete trip Message")
            let cancelText = NSLocalizedString("Cancel", comment: "Cancel delete")
            
            let alert = UIAlertController(title: deleteText, message: deleteMessageText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: deleteText, style: .destructive, handler: { action in
                self.trips.remove(at: indexPath.row)
                self.tripTableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateTitle()
            }))
            present(alert, animated: true)
        }
    }
}
