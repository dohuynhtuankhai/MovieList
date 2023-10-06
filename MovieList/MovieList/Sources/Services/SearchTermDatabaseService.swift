//
//  SearchTermDatabaseService.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 20/09/2023.
//

import Foundation
import Combine
import CoreData

protocol SearchTermDatabaseServiceProtocol {
    func getSearchTerms() -> AnyPublisher<[SearchTerm], Error>
    func saveSearchTerm(_ value: String) -> AnyPublisher<Void, Error>
    func deleteSearchTerms(_ values: [String]) -> AnyPublisher<Void, Error>
}

class SearchTermDatabaseService: SearchTermDatabaseServiceProtocol {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getSearchTerms() -> AnyPublisher<[SearchTerm], Error> {
        let request: NSFetchRequest<SearchTermEntity> = SearchTermEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \SearchTermEntity.searchDate, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let context = persistentContainer.viewContext
        
        return Future<[SearchTerm], Error> { promise in
            do {
                let searchTermEntities = try context.fetch(request)
                let searchTerms = searchTermEntities.map { SearchTerm(entity: $0) }
                promise(.success(searchTerms))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveSearchTerm(_ value: String) -> AnyPublisher<Void, Error> {
        let context = persistentContainer.newBackgroundContext()
        return Future<Void, Error> { promise in
            context.performAndWait {
                do {
                    let request: NSFetchRequest<SearchTermEntity> = SearchTermEntity.fetchRequest()
                    let searchTermEntities = try context.fetch(request)
                    let existingSearchTermValues = searchTermEntities.compactMap { $0.value }
                    
                    if let existingEntity = searchTermEntities.first(where: {$0.value == value}) {
                        existingEntity.searchDate = Date.now
                    } else {
                        let searchTermEntity = SearchTermEntity(context: context)
                        let date = Date.now
                        searchTermEntity.id = "\(Int(date.timeIntervalSince1970))\(value)"
                        searchTermEntity.value = value
                        searchTermEntity.searchDate = date
                    }
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteSearchTerms(_ values: [String]) -> AnyPublisher<Void, Error>{
        let context = persistentContainer.newBackgroundContext()
        return Future<Void, Error> { promise in
            context.performAndWait {
                do {
                    let request: NSFetchRequest<SearchTermEntity> = SearchTermEntity.fetchRequest()
                    let searchTermEntities = try context.fetch(request)
                    let filteredEntities = searchTermEntities.filter ({ item in
                        return values.contains(item.value ?? "")
                    })
                    
                    for item in filteredEntities {
                        context.delete(item)
                    }
                    
                    try context.save()
                    promise(.success(()))
                } catch {
                    print("Failed to delete Search Terms: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
