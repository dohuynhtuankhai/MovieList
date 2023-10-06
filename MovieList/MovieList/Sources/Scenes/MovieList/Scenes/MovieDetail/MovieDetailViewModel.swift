//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import Foundation
import Combine

extension MovieDetailView {
    final public class ViewModel: ObservableObject {
        @Published var movie: Movie
        
        private let movieDatabaseService: MovieDatabaseServiceProtocol
        
        let onUpdateFavorite = PassthroughSubject<Void, Never>()
        private var cancellables = Set<AnyCancellable>()
        
        public init(movie: Movie,
                    movieDatabaseService: MovieDatabaseServiceProtocol = MovieDatabaseService(persistentContainer: FavoriteMoviePersistenceManager.shared.container)) {
            self.movie = movie
            self.movieDatabaseService = movieDatabaseService
        }
    }
}

// MARK: - Favorite Movie Functions
extension MovieDetailView.ViewModel {
    func toggleFavoriteAction() {
        if movie.isFavorite {
            removeFavoriteMove()
        } else {
            addFavoriteMovie()
        }
    }
    
    private func addFavoriteMovie() {
        movieDatabaseService
            .saveFavoriteMovie(movie)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to save Movie with id \(self.movie.id) to core data: \(error)")
                }
            } receiveValue: { [weak self] _ in
                print("Add movie \(String(describing: self?.movie.id))")
                self?.movie.isFavorite = true
                self?.onUpdateFavorite.send()
            }.store(in: &cancellables)
    }
    
    private func removeFavoriteMove() {
        movieDatabaseService
            .deleteFavoriteMovie(movie)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to save Movie with id \(self.movie.id) to core data: \(error)")
                }
            } receiveValue: { [weak self] _ in
                print("Remove movie \(String(describing: self?.movie.id))")
                self?.movie.isFavorite = false
                self?.onUpdateFavorite.send()
            }.store(in: &cancellables)
    }
}

