//
//  HNTopViewPad.swift
//  HNSwift
//
//  Created by Chris on 2025/5/11.
//

import SwiftUI

struct HNTopViewPad: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @StateObject private var searchViewModel = PostSearchViewModel()
    @State private var selectedPost: Post?
    @State private var isLoading = false
    @State private var isShowingToast = false
    
    var body: some View {
        let base = HNTopViewBase(
            searchViewModel: searchViewModel,
            selectedPost: $selectedPost,
            isShowingToast: $isShowingToast,
            isLoading: $isLoading
        )
        
        NavigationSplitView(columnVisibility: $columnVisibility) {
            base.listContent
        } detail: {
            base.detailContent
        }
        .navigationSplitViewStyle(.balanced)
    }
}
#Preview {
    HNTopViewPad()
}
