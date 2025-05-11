//
//  HNTopViewBase.swift
//  HNSwift
//
//  Created by Chris on 2025/5/11.
//

import SwiftUI

struct HNTopViewBase {
    @ObservedObject var searchViewModel : PostSearchViewModel
    @EnvironmentObject var bookmarkManager: BookmarkManager
    @Binding var selectedPost: Post?
    @Binding var isShowingToast : Bool
    @Binding var isLoading : Bool
    
    let postService = PostService()
    
    var listContent: some View {
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
        .toast(isShowing: $isShowingToast, message: "url copied.")
        .loading(isLoading: isLoading)
    }
    
    var detailContent: some View {
        Group {
            if let post = selectedPost {
                if let urlString = post.url, let url = URL(string: urlString) {
                    SafariViewWrapper(url: url, isLoading: $isLoading)
                } else {
                    ErrorView(post: post)
                }
            } else {
                Text("Select a post to view")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func handlePostSelection(_ post: Post) {
        guard post.url != nil else { return }
        selectedPost = post
    }
}

