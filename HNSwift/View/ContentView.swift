//
//  ContentView.swift
//  HNSwift
//
//  Created by ByteDance on 2024/11/1.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bookmarkManager = BookmarkManager()
    
    var body: some View {
        TabView {
            HNTopView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Top")
                }
            
            HNShowView()
                .tabItem {
                    Image(systemName: "eye.fill")
                    Text("Show")
                }
        }
        .environmentObject(bookmarkManager)
    }
}

#Preview {
    ContentView()
}
