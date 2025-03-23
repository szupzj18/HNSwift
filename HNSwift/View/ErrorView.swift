//
//  ErrorView.swift
//  HNSwift
//
//  Created by Chris on 2025/3/23.
//

import SwiftUI

struct ErrorView: View {
    var url: String
    var body: some View {
        Text("Something went wrong :(")
            .font(.title)
            .foregroundColor(.red)
            .padding()
        Text("Failed to load \(url)")
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}

#Preview {
    ErrorView(url: "https://www.google.com")
}
