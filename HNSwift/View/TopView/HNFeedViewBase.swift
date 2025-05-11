//
//  HNTopViewBase.swift
//  HNSwift
//
//  Created by Chris on 2025/5/11.
//

import SwiftUI

struct HNFeedViewBase : View {
    @StateObject var searchViewModel = PostSearchViewModel()
    @EnvironmentObject var bookmarkManager: BookmarkManager
    @Binding var selectedPost: Post?
    @State var isShowingToast : Bool = false
    @State var isLoading : Bool = false
    
    let postType : PostType
    let postService = PostService()
    
    var body: some View {
        listContent
    }
    
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
        .navigationTitle(title)
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
                var fetchedPosts = try await self.postService.fetchPosts(for: postType)
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
    
    func handlePostSelection(_ post: Post) {
        guard post.url != nil else { return }
        selectedPost = post
    }
    
    var title: String {
        switch postType {
        case .show:
            "HN Show"
        case .top:
            "HN Top 10"
        }
    }
}

