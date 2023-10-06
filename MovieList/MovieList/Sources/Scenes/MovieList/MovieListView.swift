//
//  MovieListView.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(String.movieListTitle)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            viewModel.fetchSearchTerms()
            viewModel.fetchMovies()
        }
    }
}

extension MovieListView {
    // MARK: - Content
    @ViewBuilder private var content: some View {
        ScrollView {
            VStack {
                searchBarView
                segmentControl
                if viewModel.searchTerm.isEmpty {
                    searchTermsList
                } else {
                    if viewModel.currentTab == .all {
                        allList
                    } else {
                        favoriteList
                    }
                }
            }
            .padding(.tinyPadding)
        }
    }
    
    @ViewBuilder private var searchBarView: some View {
        SearchBarView(searchText: $viewModel.searchTerm, placeHolder: String.searchBarPrompt) {
            $viewModel.searchTerm.wrappedValue = ""
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    @ViewBuilder private var segmentControl: some View {
        Picker(String.segmentControlTitle, selection: $viewModel.currentTab) {
            ForEach(MovieTab.allCases) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    // MARK: - All List
    @ViewBuilder private var allList: some View {
        LazyVStack {
            ForEach(viewModel.allMovies, id: \.id) { movie in
                NavigationLink(destination: MovieDetailView(viewModel:.init(movie: movie)).environmentObject(viewModel)) {
                    VStack {
                        MovieView(viewModel: .init(movie: movie, onTapFavourite: {
                            viewModel.toggleFavoriteAction(id: movie.id)
                        }))
                        Divider()
                    }
                }.simultaneousGesture(TapGesture().onEnded {
                    viewModel.saveSearchTerm()
                })
            }
        }
    }
    
    // MARK: - Favorite List
    @ViewBuilder private var favoriteList: some View {
        LazyVStack {
            ForEach(viewModel.favoriteMovies, id: \.id) { movie in
                NavigationLink(destination: MovieDetailView(viewModel:.init(movie: movie)).environmentObject(viewModel)) {
                    VStack {
                        MovieView(viewModel: .init(movie: movie, onTapFavourite: {
                            viewModel.toggleFavoriteAction(id: movie.id)
                        }))
                        Divider()
                    }
                    
                }.simultaneousGesture(TapGesture().onEnded {
                    viewModel.saveSearchTerm()
                })
            }
        }
    }
    
    // MARK: - Old Search Term List
    @ViewBuilder private var searchTermsList: some View {
        if !viewModel.oldSearchTerms.isEmpty {
            VStack {
                searchTermsListHeader
                Divider()
                LazyVStack {
                    ForEach(viewModel.oldSearchTerms, id: \.id) { searchTerm in
                        HStack {
                            SearchTermView(text: searchTerm.value)
                            Spacer()
                        }
                        .onTapGesture {
                            viewModel.searchTerm = searchTerm.value
                        }
                    }
                }
            }
            .padding(.tinyPadding)
        }
    }
    
    private var searchTermsListHeader: some View {
        HStack {
            Text(String.searchHistoryTitle)
                .font(.systemBold(size: .medium))
                .foregroundColor(.gray)
            Spacer()
            Button {
                viewModel.removeSearchTerms(searchTerms: viewModel.oldSearchTerms)
            } label: {
                Text(String.clearAllHistory)
            }
        }
    }
}

// MARK: - Constants
private extension String {
    static let movieListTitle = "Movies"
    static let searchBarPrompt = "Enter a movie name"
    static let searchHistoryTitle = "Recently Searched"
    static let clearAllHistory = "Clear All"
    static let segmentControlTitle = "Select Movie"
}

// MARK: - Preview
struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: .init(moviesRepository: MoviesServicePreview()))
            .previewDisplayName("Default")
    }
}
