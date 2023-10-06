//
//  MovieListApp.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import SwiftUI

@main
struct MovieListApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: .init())
                .preferredColorScheme(.light)
        }
    }
}
