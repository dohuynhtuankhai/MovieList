//
//  MovieDatabaseServicePreview.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 20/09/2023.
//

import Foundation
import Combine

final class MovieDatabaseServicePreview: MovieDatabaseServiceProtocol {
    var movies: [Movie] = []
    var onSaveFavoriteMovie: (() -> Void) = {}
    var onDeleteFavoriteMovie: (() -> Void) = {}
    
    func getFavoriteMovies(searchTerm: String) -> AnyPublisher<[Movie], Never> {
        return Just(movies).eraseToAnyPublisher()
    }
    
    func saveFavoriteMovie(_ movie: Movie) -> AnyPublisher<Void, Error> {
        return Result<Void, Error> {
            return onSaveFavoriteMovie()
        }
        .publisher
        .eraseToAnyPublisher()
    }
    
    func deleteFavoriteMovie(_ movie: Movie) -> AnyPublisher<Void, Error> {
        return Result<Void, Error> {
            return onDeleteFavoriteMovie()
        }
        .publisher
        .eraseToAnyPublisher()
    }
    
    
}
