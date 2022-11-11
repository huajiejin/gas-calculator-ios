//
//  TripTableViewController.swift
//  Gas Calculator
//
//  Created by Jin on 2022-11-08.
//

import UIKit

class TripTableViewController: UIViewController {
    
    @IBOutlet weak var tripTableView: UITableView!
    
    var trips: [Trip] = []
    
    required init?(coder aDcoder: NSCoder) {
        super.init(coder: aDcoder)
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.performSegueToTripForm(_:)))
    }
    
    @objc func performSegueToTripForm(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueToTripForm", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToTripForm":
            let tripFormViewController = segue.destination as! TripFormViewController
            if let row = tripTableView.indexPathForSelectedRow?.row {
                tripFormViewController.trip = trips[row]
            } else {
                let trip = Trip(origin: "", destination: "")
                tripFormViewController.trip = trip
                trips.append(trip)
            }
        default:
            preconditionFailure("Segue indentifier \(String(describing: segue.identifier)) does not exists")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tripTableView.dataSource = self
        tripTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tripTableView.reloadData()
    }
}

extension TripTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // only create cells displayed on the screen by using dequeueReusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripTableCell", for: indexPath)
        let trip = trips[indexPath.row]
        let gasAmountInGallonsText = Utils.numberFormatter.string(from: NSNumber(value: trip.gasAmountInGallons)) ?? ""
        cell.textLabel?.text = "\(trip.origin)  \(trip.destination)  \(gasAmountInGallonsText)"
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
            }))
            present(alert, animated: true)
        }
    }
}
