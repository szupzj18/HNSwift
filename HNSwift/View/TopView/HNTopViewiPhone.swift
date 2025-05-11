//
//  HNTopViewiPhone.swift
//  HNSwift
//
//  Created by Chris on 2025/5/11.
//

import SwiftUI

struct HNTopViewiPhone: View {
    @StateObject private var searchViewModel = PostSearchViewModel()
    @State private var selectedPost: Post?
    @State private var isLoading = false
    @State private var isShowingToast = false

    var body: some View {
        let base = HNTopViewBase(
            searchViewModel: searchViewModel,
            selectedPost: $selectedPost,
            isShowingToast: $isShowingToast,
            isLoading: $isLoading
        )

        NavigationView {
            base.listContent
        }
        .sheet(item: $selectedPost) { post in
            Group {
                if let urlString = post.url, let url = URL(string: urlString) {
                    SafariView(url: url, isLoading: $isLoading)
                } else {
                    ErrorView(post: post)
                }
            }
        }
    }
}

#Preview {
    HNTopViewiPhone()
}
