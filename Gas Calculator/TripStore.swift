//
//  TripStore.swift
//  Gas Calculator
//
//  Created by Jin on 2022-11-10.
//

import UIKit

class TripStore {
    var trips = [Trip]()
    let tripsArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentDirectories.first!.appendingPathComponent("trips.archive")
    }()
    
    init() {
        if let archivedTrips = NSKeyedUnarchiver.unarchiveObject(withFile: tripsArchiveURL.path) {
            trips = archivedTrips as! [Trip]
        }
    }

    func archive() -> Bool {
        return NSKeyedArchiver.archiveRootObject(trips, toFile: tripsArchiveURL.path)
    }
}
