//
//  HNTopView.swift
//  HNSwift
//
//  Created on 2024/11/1.
//

import SwiftUI

struct HNTopView: View {
    @StateObject private var searchViewModel = PostSearchViewModel()
    @State private var selectedPost: Post?
    @State private var isShowingSafariView = false
    @State private var isShowingToast = false
    @State private var isLoading = false
    
    private let postService = PostService()
    
    var body: some View {
        NavigationView {
            List(searchViewModel.filteredPosts) { post in
                Button(action: {
                    if let _ = post.mobileURL {
                        selectedPost = post
                        isShowingSafariView = true
                    }
                }) {
                    PostItemView(post: post) {
                        isShowingToast = true
                    }
                }
            }
            .navigationTitle("HN Top 10")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .searchable(text: $searchViewModel.searchText, prompt: "🔍")
            .onChange(of: searchViewModel.searchText, { oldValue, newValue in
                searchViewModel.filterPosts()
            })
            .task {
                do {
                    isLoading = true
                    var fetchedPosts = try await self.postService.fetchPosts(for: .top)
                    fetchedPosts.sort { $0.score > $1.score }
                    searchViewModel.updatePosts(fetchedPosts)
                } catch {
                    print("Failed to fetch posts\(error)")
                }
                isLoading = false
            }
            .sheet(isPresented: $isShowingSafariView) {
                if let urlString = selectedPost?.url, let url = URL(string: urlString) {
                    SafariView(url: url, isLoading: $isLoading)
                }
            }
            .toast(isShowing: $isShowingToast, message: "url copied.")
            .loading(isLoading: isLoading)
        }
    }
}

#Preview {
    HNTopView()
}
