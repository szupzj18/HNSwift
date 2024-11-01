//
//  ContentView.swift
//  HNSwift
//
//  Created by ByteDance on 2024/11/1.
//

import SwiftUI

struct ContentView: View {
    @State private var posts: [Post] = []
    @State private var selectedPost: Post?
    @State private var isShowingSafariView = false
    private let postService = PostService()
    var body: some View {
        NavigationView {
            List(posts) { post in
                Button(action: {
                    if let url = post.mobileURL {
                        selectedPost = post
                        isShowingSafariView = true
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text("by \(post.by)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("HN Top 10")
            .task {
                do {
                    self.posts = try await self.postService.fetchPosts()
                } catch {
                    print("Failed to fetch posts\(error)")
                }
                
            }
            .sheet(isPresented: $isShowingSafariView) {
                if let urlString = selectedPost?.url, let url = URL(string: urlString) {
                    SafariView(url: url)
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
