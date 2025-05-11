//
//  HNTopViewiPhone.swift
//  HNSwift
//
//  Created by Chris on 2025/5/11.
//

import SwiftUI

struct HNTopViewiPhone: View {
    let postType: PostType
    @State private var selectedPost: Post?

    var body: some View {
        NavigationView {
            HNViewBase(
                selectedPost: $selectedPost,
                postType: postType
            )
        }
        .sheet(item: $selectedPost) { post in
            Group {
                if let urlString = post.url, let url = URL(string: urlString) {
                    SafariView(url: url)
                } else {
                    ErrorView(post: post)
                }
            }
        }
    }
}

//#Preview {
//    HNTopViewiPhone(postType: .show, selectedPost: )
//        .environmentObject(BookmarkManager())
//}
