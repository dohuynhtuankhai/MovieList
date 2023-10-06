//
//  SearchTermView.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 21/09/2023.
//

import SwiftUI

struct SearchTermView: View {
    let text: String
    var body: some View {
        HStack(spacing: .picoPadding) {
            Image(systemName: "magnifyingglass.circle")
                .resizable()
                .frame(width: .mediumSize, height: .mediumSize)
            Text(text)
                .font(.systemSemibold(size: .regular))
            
        }
        .foregroundColor(.white)
        .padding(EdgeInsets(top: .nanoPadding, leading: .smallPadding, bottom: .nanoPadding, trailing: .smallPadding))
        .background(
            Capsule()
                .fill(Color.gray)
        )
    }
}

struct SearchTermView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTermView(text: "Testing")
    }
}
