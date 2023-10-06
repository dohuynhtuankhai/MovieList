//
//  SearchTerm.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 20/09/2023.
//

import Foundation

struct SearchTerm {
    let id: String
    let value: String
    let searchDate: Date
    
    init(id: String, value: String, searchDate: Date = Date.now) {
        self.id = id
        self.value = value
        self.searchDate = searchDate
    }
    
    init(entity: SearchTermEntity) {
        id = entity.id ?? ""
        value = entity.value ?? ""
        searchDate = entity.searchDate ?? Date.now
    }
}
