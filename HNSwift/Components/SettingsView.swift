//
//  SettingsView.swift
//  HNSwift
//
//  Created by Chris on 2024/11/2.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(DefaultKeys.enableReaderMode) private var enableReaderMode = false
    var body: some View {
        List {
            Section {
                Toggle(isOn: $enableReaderMode) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName:"book.fill")
                                .foregroundColor(.blue)
                            Text("Reading Mode")
                        }
                        Text("自动开启 Safari 阅读器视图")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.vertical)
                    }
                }
            }
        }
        .navigationTitle("🔧 Settings")
    }
}

#Preview{
    SettingsView()
}
