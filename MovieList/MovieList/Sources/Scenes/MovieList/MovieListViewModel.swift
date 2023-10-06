//
//  MovieListViewModel.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import Foundation
import Combine
import CoreData

extension MovieListView {
    enum MovieTab: String, CaseIterable, Identifiable {
        case all = "All Movies"
        case favourite = "Favorite Movies"
        
        var id: String { self.rawValue }
    }
    
    final public class ViewModel: ObservableObject {
        @Published var searchTerm: String = ""
        @Published var allMovies: [Movie] = []
        @Published var favoriteMovies: [Movie] = []
        @Published var oldSearchTerms: [SearchTerm] = []
        @Published var currentTab: MovieTab = .all
        @Published var isShowDetail = false
        
        private let movieService: MoviesServiceProtocol
        private let movieDatabaseService: MovieDatabaseServiceProtocol
        private let searchTermDatabaseService: SearchTermDatabaseServiceProtocol
        
        private let getSearchTermHistory = PassthroughSubject<Void, Never>()
        private let getFavoriteMovies = PassthroughSubject<Void, Never>()
        private let getAllMovies = PassthroughSubject<Void, Never>()
        private var cancellables = Set<AnyCancellable>()
        
        init(moviesRepository: MoviesServiceProtocol = MoviesService(),
             movieDatabaseService: MovieDatabaseServiceProtocol = MovieDatabaseService(persistentContainer: FavoriteMoviePersistenceManager.shared.container),
             searchTermDatabaseService: SearchTermDatabaseServiceProtocol = SearchTermDatabaseService(persistentContainer: SearchTermsPersistenceManager.shared.container)) {
            self.movieService = moviesRepository
            self.movieDatabaseService = movieDatabaseService
            self.searchTermDatabaseService = searchTermDatabaseService
            bind()
        }
    }
}

// MARK: - Bindings
private extension MovieListView.ViewModel {
    func bind() {
        let searchTermPublisher = Publishers.CombineLatest(getAllMovies.prepend(), $searchTerm.debounce(for: 0.3, scheduler: DispatchQueue.main).removeDuplicates())
            .map { [unowned self] _, searchTerm in
                return self.movieService.getMovies(searchTerm: searchTerm)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)

        let favoriteMoviesPublisher = Publishers.CombineLatest(getFavoriteMovies.prepend(), $searchTerm
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates())
            .flatMap { _, searchTerm -> AnyPublisher<[Movie], Never> in
                return self.movieDatabaseService.getFavoriteMovies(searchTerm: searchTerm)
            }

        let combinedPublisher = Publishers.Zip(searchTermPublisher, favoriteMoviesPublisher)

        combinedPublisher
            .sink { [weak self] movies, favoriteMovies in
                self?.updateMovies(allMovies: movies, favoriteMovies: favoriteMovies)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Favorite Movie Functions
extension MovieListView.ViewModel {
    func fetchMovies() {
        getAllMovies.send()
        getFavoriteMovies.send()
    }
    
    func toggleFavoriteAction(id: Int) {
        if let _ = favoriteMovies.first(where: { $0.id == id}) {
            removeFavoriteMove(id: id)
        } else {
             addFavoriteMovie(id: id)
        }
    }
    
    private func addFavoriteMovie(id: Int) {
        guard let movie = allMovies.first(where: { $0.id == id}) else {
            return
        }
        
        movieDatabaseService
            .saveFavoriteMovie(movie)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to save Movie with id \(id) to core data: \(error)")
                }
            } receiveValue: { [weak self] _ in
                print("Add movie \(id)")
                self?.fetchMovies()
            }.store(in: &cancellables)
    }
    
    private func removeFavoriteMove(id: Int) {
        guard let movie = favoriteMovies.first(where: { $0.id == id}) else {
            return
        }
        
        movieDatabaseService
            .deleteFavoriteMovie(movie)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to save Movie with id \(id) to core data: \(error)")
                }
            } receiveValue: { [weak self] _ in
                print("Remove movie \(id)")
                self?.fetchMovies()
            }.store(in: &cancellables)
    }
}

// MARK: - Search Terms Functions
extension MovieListView.ViewModel {
    func fetchSearchTerms() {
        searchTermDatabaseService
            .getSearchTerms()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch search terms: \(error)")
                }
            } receiveValue: { [weak self] searchTerms in
                self?.oldSearchTerms = searchTerms
            }.store(in: &cancellables)
    }
    
    func saveSearchTerm() {
        searchTermDatabaseService
            .saveSearchTerm(searchTerm)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to save Search Term to core data: \(error)")
                }
            } receiveValue: { [weak self] _ in
                self?.fetchSearchTerms()
            }.store(in: &cancellables)
    }
    
    func removeSearchTerms(searchTerms: [SearchTerm]) {
        searchTermDatabaseService.deleteSearchTerms(oldSearchTerms.map { String($0.value)})
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to delete Search Terms: \(error)")
                }
            } receiveValue: { [weak self] _ in
                self?.fetchSearchTerms()
            }.store(in: &cancellables)
    }
}

// MARK: - Helpers
extension MovieListView.ViewModel {
    func updateMovies(allMovies: [Movie], favoriteMovies: [Movie]) {
        var currentMovies = allMovies
        for index in allMovies.indices {
            let movie = allMovies[index]
            if favoriteMovies.contains(where: { $0.id == movie.id }) {
                currentMovies[index].isFavorite = true
            } else {
                currentMovies[index].isFavorite = false
            }
        }
        self.allMovies = currentMovies
        self.favoriteMovies = favoriteMovies
    }
}
