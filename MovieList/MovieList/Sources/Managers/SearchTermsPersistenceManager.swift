//
//  File.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 20/09/2023.
//

import Foundation
import CoreData

class SearchTermsPersistenceManager {
    static let shared = SearchTermsPersistenceManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "SearchTerm")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }
}
