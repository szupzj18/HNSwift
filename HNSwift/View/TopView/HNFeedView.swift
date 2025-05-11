//
//  HNTopView.swift
//  HNSwift
//
//  Created on 2024/11/1.
//

import SwiftUI

struct HNFeedView: View {
    @EnvironmentObject private var bookmarkManager : BookmarkManager
    let postType : PostType
    
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                HNTopViewPad(postType: postType)
            } else {
                HNTopViewiPhone(postType: postType)
            }
        }
        .environmentObject(bookmarkManager)
    }
}

#Preview {
    HNFeedView(postType: .show)
        .environmentObject(BookmarkManager()) // Add this for previews
}
