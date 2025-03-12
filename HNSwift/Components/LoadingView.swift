//
//  LoadingView.swift
//  HNSwift
//
//  Created by Chris on 2024/11/3.
//

import SwiftUI

struct LoadingViewModifier : ViewModifier {
    var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                LoadingView()
            }
        }
    }
}

extension View {
    func loading(isLoading: Bool) -> some View {
        self.modifier(LoadingViewModifier(isLoading: isLoading))
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("加载中...")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    LoadingView()
}
