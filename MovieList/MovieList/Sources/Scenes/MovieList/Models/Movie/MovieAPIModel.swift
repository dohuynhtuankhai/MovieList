//
//  File.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import Foundation

struct MovieAPIModel: Decodable {
    let resultCount: Int
    let results: [Movie]
}
