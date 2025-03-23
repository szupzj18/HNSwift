//
//  PostItemView.swift
//  HNSwift
//
//  Created by ByteDance on 2024/11/1.
//

import SwiftUI

struct PostItemView: View {
    let post: Post
    let onCopyURL: () -> Void
    @StateObject private var bookmarkManager = BookmarkManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.headline)
            HStack {
                Text("by \(post.by)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("score \(post.score)")
                    .font(.footnote)
                    .foregroundColor(.cyan)
            }
            
        }
        .contextMenu(menuItems: {
            if let urlString = post.url, let url = URL(string:urlString) {
                Button(action: {
                    UIApplication.shared.open(url)
                }, label: {
                    Label("open in safari", systemImage: "safari")
                })
                
                Button(action: {
                    UIPasteboard.general.string = urlString
                    onCopyURL()
                }, label: {
                    Label("copy url", systemImage: "doc.on.doc")
                })
                
                Button(action: {
                    bookmarkManager.toggleBookmark(post)
                }) {
                    Label(bookmarkManager.isBookmarked(post) ? "Unbookmark" : "Bookmark",
                          systemImage: bookmarkManager.isBookmarked(post) ? "bookmark.slash" : "bookmark")
                }
                .tint(.blue)
            }
        })
        .environmentObject(bookmarkManager)
    }
}

#Preview {
    PostItemView(post: Post(id: 01, title: "Test Post", by: "chris", time: 0, text: "hello", url: "", score: 0, descendants: 0, kids: nil)) {
        
    }
}
