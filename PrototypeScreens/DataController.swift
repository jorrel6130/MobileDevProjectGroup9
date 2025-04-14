//
//  DataController.swift
//  PrototypeScreens
//
//  Created by Jorrel Tigbayan on 2025-04-14.
//

import Foundation
import CoreData

// Responsible for loading core data to be used in app
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "PrototypeScreens")
    
    init() {
        container.loadPersistentStores {
            description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
