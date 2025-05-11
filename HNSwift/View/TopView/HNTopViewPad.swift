//
//  HNTopViewPad.swift
//  HNSwift
//
//  Created by Chris on 2025/5/11.
//

import SwiftUI

struct HNTopViewPad: View {
    let postType: PostType
    @State var selectedPost: Post?
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @EnvironmentObject private var bookmarkManager : BookmarkManager
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            HNViewBase(selectedPost: $selectedPost, postType: postType)
        } detail: {
            detailContent
        }
        .navigationSplitViewStyle(.balanced)
        .environmentObject(bookmarkManager)
    }
    
    var detailContent: some View {
        Group {
            if let post = selectedPost {
                if let urlString = post.url, let url = URL(string: urlString) {
                    SafariViewWrapper(url: url)
                } else {
                    ErrorView(post: post)
                }
            } else {
                Text("Select a post to view")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    HNTopViewPad(postType: .show)
}
