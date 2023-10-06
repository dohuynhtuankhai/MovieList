//
//  MovieDatabaseService.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 20/09/2023.
//

import Foundation
import Combine
import CoreData

protocol MovieDatabaseServiceProtocol {
    func getFavoriteMovies(searchTerm: String) -> AnyPublisher<[Movie], Never>
    func saveFavoriteMovie(_ movie: Movie) -> AnyPublisher<Void, Error>
    func deleteFavoriteMovie(_ movie: Movie) -> AnyPublisher<Void, Error>
}

class MovieDatabaseService: MovieDatabaseServiceProtocol {
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getFavoriteMovies(searchTerm: String) -> AnyPublisher<[Movie], Never> {
        let request: NSFetchRequest<FavoriteMovieEnity> = FavoriteMovieEnity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \FavoriteMovieEnity.trackName, ascending: true)
        let searchTermPredicate = NSPredicate(format: "trackName CONTAINS[cd] %@", searchTerm)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = searchTermPredicate
        let context = persistentContainer.viewContext
        
        return Future<[Movie], Error> { promise in
            do {
                let moviesEntities = try context.fetch(request)
                let movies = moviesEntities.map { Movie(entity: $0) }
                promise(.success(movies))
            } catch {
                promise(.failure(error))
            }
        }
        .catch { error -> Just<[Movie]> in
            print("Failed to fetch Favorite Movies: \(error)")
            return Just([Movie]())
        }
        .eraseToAnyPublisher()
    }
    
    func saveFavoriteMovie(_ movie: Movie) -> AnyPublisher<Void, Error> {
        let context = persistentContainer.newBackgroundContext()
        return Future<Void, Error> { promise in
            context.performAndWait {
                do {
                    let request: NSFetchRequest<FavoriteMovieEnity> = FavoriteMovieEnity.fetchRequest()
                    let favoriteMovieEnities = try context.fetch(request)
                    let existingFavoriteMovieId = favoriteMovieEnities.compactMap { Int($0.trackId) }
                    
                    if !existingFavoriteMovieId.contains(movie.id) {
                        let favoriteMovieEnity = FavoriteMovieEnity(context: context)
                        favoriteMovieEnity.trackId = Int64(movie.id)
                        favoriteMovieEnity.currency = movie.currency
                        favoriteMovieEnity.imageUrl = movie.imageUrl
                        favoriteMovieEnity.isFavorite = true
                        favoriteMovieEnity.longDescription = movie.longDescription
                        favoriteMovieEnity.primaryGenreName = movie.primaryGenreName
                        favoriteMovieEnity.trackName = movie.trackName
                        favoriteMovieEnity.trackPrice = movie.trackPrice
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
    
    func deleteFavoriteMovie(_ movie: Movie) -> AnyPublisher<Void, Error> {
        let context = persistentContainer.newBackgroundContext()
        return Future<Void, Error> { promise in
            context.performAndWait {
                do {
                    let request: NSFetchRequest<FavoriteMovieEnity> = FavoriteMovieEnity.fetchRequest()
                    let favoriteMovieEnities = try context.fetch(request)
                    guard let filteredEntity = favoriteMovieEnities.first(where: { Int($0.trackId) == movie.id }) else {
                        promise(.success(()))
                        return
                    }
                    
                    context.delete(filteredEntity)
                    
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
