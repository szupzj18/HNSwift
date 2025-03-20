//
//  ContentView.swift
//  HNSwift
//
//  Created by ByteDance on 2024/11/1.
//

import SwiftUI

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
}
