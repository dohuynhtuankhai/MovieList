//
//  SearchBarView.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 21/09/2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    let placeHolder: String
    let cancel: () -> Void
    
    var body: some View {
        HStack(spacing: .regularPadding) {
            searchTextField
            cancelButton
        }
    }
}

extension SearchBarView {
    @ViewBuilder private var searchTextField: some View {
        HStack {
            if searchText.isEmpty {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.gray)
            }
            TextField(placeHolder, text: $searchText)
                .font(.system(size: .regular))
                .foregroundColor(Color.black)
                .autocapitalization(.none)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .tint(.gray)
                }
            }
        }
        .padding(EdgeInsets(top: 0, leading: .smallPadding, bottom: 0, trailing: .smallPadding))
        .frame(height: .largeSize)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(.extraLargePlusRadius)
    }
    
    private var cancelButton: some View {
        Button(action: cancel) {
            Text("Cancel")
                .font(.systemBold(size: .regular))
                .foregroundColor(Color.blue)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    struct SearchViewContainer: View {
        @State var searchText = ""

        var body: some View {
            SearchBarView(searchText: $searchText, placeHolder: "Search Defect", cancel: {})
        }
    }
    static var previews: some View {
        SearchViewContainer()
    }
}
