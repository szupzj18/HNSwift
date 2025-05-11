//
//  HNTopView.swift
//  HNSwift
//
//  Created on 2024/11/1.
//

import SwiftUI

struct HNTopView: View {
    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            HNTopViewPad()
        } else {
            HNTopViewiPhone()
        }
        #else
        HNTopViewiPad()
        #endif
    }
}

#Preview {
    HNTopView()
        .environmentObject(BookmarkManager()) // Add this for previews
}
