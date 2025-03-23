//
//  HNTopView.swift
//  HNSwift
//
//  Created on 2024/11/1.
//

import SwiftUI

struct HNTopView: View {
    @StateObject private var searchViewModel = PostSearchViewModel()
    @StateObject private var bookmarkManager = BookmarkManager()
    @State private var selectedPost: Post?
    @State private var isShowingToast = false
    @State private var isLoading = false
    
    private let postService = PostService()
    
    var body: some View {
        NavigationView {
            List(searchViewModel.filteredPosts) { post in
                Button(action: {
                    handlePostSelection(post)
                }) {
                    PostItemView(post: post) {
                        isShowingToast = true
                    }
                }
            }
            .navigationTitle("HN Top 10")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        MarkPostsView()
                    } label: {
                        Image(systemName: "bookmark")
                    }
                }
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
            .sheet(item: $selectedPost) { post in
                if let urlString = post.url, let url = URL(string: urlString) {
                    SafariView(url: url, isLoading: $isLoading)
                } else {
                    ErrorView(url: post.url ?? "")
                }
            }
            .toast(isShowing: $isShowingToast, message: "url copied.")
            .loading(isLoading: isLoading)
        }
        .environmentObject(bookmarkManager)
    }
    
    private func handlePostSelection(_ post: Post) {
        // Only proceed if the post has a valid URL
        guard post.url != nil else { return }
        
        // Update on main thread with slight delay to ensure state consistency
        DispatchQueue.main.async {
            self.selectedPost = post
            // Sheet will present automatically because we're using sheet(item:)
        }
    }
}

#Preview {
    HNTopView()
}
