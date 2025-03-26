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

struct LoadingView : View {
    let characters = Array("LOADING") // split LOADING into arrays
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var currentIndex = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(characters.enumerated()), id: \.offset) { index, char in
                Text(String(char))
                    .font(.largeTitle)
                    .foregroundStyle(index == currentIndex ? .blue : .primary)
                    .animation(.easeInOut, value: currentIndex)
            }
        }
        .onReceive(timer) { _ in
            currentIndex = (currentIndex + 1) % characters.count
        }
    }
}

#Preview {
    LoadingView()
}
