//
//  ContentView.swift
//  HNSwift
//
//  Created by ByteDance on 2024/11/1.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var posts: [Post] = []
    @State private var filteredPosts: [Post] = []
    @State private var selectedPost: Post?
    @State private var isShowingSafariView = false
    @State private var isShowingToast = false
    private let postService = PostService()
    var body: some View {
        NavigationView {
            List(filteredPosts) { post in
                Button(action: {
                    if let url = post.mobileURL {
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
            .searchable(text: $searchText, prompt: "🔍")
            .onChange(of: searchText, { oldValue, newValue in
                self.filterPosts()
            })
            .task {
                do {
                    var fetchedPosts = try await self.postService.fetchPosts()
                    fetchedPosts.sort { $0.score > $1.score }
                    self.posts = fetchedPosts
                    self.filteredPosts = fetchedPosts
                } catch {
                    print("Failed to fetch posts\(error)")
                }
                
            }
            .sheet(isPresented: $isShowingSafariView) {
                if let urlString = selectedPost?.url, let url = URL(string: urlString) {
                    SafariView(url: url)
                }
                
            }
            .toast(isShowing: $isShowingToast, message: "url copied.")
        }
    }
    
    func filterPosts() {
        if searchText.isEmpty {
            filteredPosts = posts
        } else {
            filteredPosts = posts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    ContentView()
}
