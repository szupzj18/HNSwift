//
//  ErrorView.swift
//  HNSwift
//
//  Created by Chris on 2025/3/23.
//

import SwiftUI

struct ErrorView: View {
    var post: Post
    var body: some View {
        Image(systemName: "exclamationmark.triangle")
            .foregroundStyle(.red)
        Text("Something went wrong :(")
            .font(.title)
            .foregroundColor(.red)
            .padding()
        Text("Failed to load \(post.title)")
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}

#Preview {
    ErrorView(post: Post(id: 1, title: "Title", by: "https://www.google.com", time: 12345678, text: "1234567890", url: nil, score: 0, descendants: 0, kids: nil))
}
