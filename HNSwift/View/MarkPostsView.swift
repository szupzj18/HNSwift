//
//  MarkPostsView.swift
//  HNSwift
//
//  Created by Chris on 2025/3/23.
//

import SwiftUI

struct MarkPostsView: View {
    @EnvironmentObject private var bookmarkManager: BookmarkManager
    @State private var selectedPost: Post?
    @State private var isShowingToast = false
    @State private var isLoading = false
    
    var body: some View {
        List {
            if bookmarkManager.bookmarkedPosts.isEmpty {
                Text("No bookmarked posts yet")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(bookmarkManager.bookmarkedPosts) { post in
                    Button(action: {
                        if let _ = post.url {
                            selectedPost = post
                        }
                    }) {
                        PostItemView(post: post) {
                            isShowingToast = true
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button(role: .destructive) {
                            bookmarkManager.toggleBookmark(post)
                        } label: {
                            Label("Remove", systemImage: "bookmark.slash")
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .navigationTitle("Bookmarks")
        .sheet(item: $selectedPost) { post in 
            if let urlString = post.url, let url = URL(string: urlString) {
                SafariView(url: url)
            }
        }
        .toast(isShowing: $isShowingToast, message: "url copied.")
        .environmentObject(bookmarkManager)
    }
}

#Preview {
    NavigationView {
        MarkPostsView()
            .environmentObject(BookmarkManager())
    }
}
