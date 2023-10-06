//
//  PersistenceManager.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 20/09/2023.
//

import Foundation
import CoreData

class FavoriteMoviePersistenceManager {
    static let shared = FavoriteMoviePersistenceManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FavoriteMovie")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }
}
