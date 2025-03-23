//
//  BookmarkManager.swift
//  HNSwift
//
//  Created by Chris on 2025/3/23.
//

import Foundation
import SwiftUI

class BookmarkManager: ObservableObject {
    @Published var bookmarkedPosts: [Post] = []
    private let bookmarkKey = "bookmarkedPosts"
    
    init() {
        loadBookmarks()
    }
    
    func isBookmarked(_ post: Post) -> Bool {
        bookmarkedPosts.contains { $0.id == post.id }
    }
    
    func toggleBookmark(_ post: Post) {
        if isBookmarked(post) {
            bookmarkedPosts.removeAll { $0.id == post.id }
        } else {
            bookmarkedPosts.append(post)
        }
        saveBookmarks()
    }
    
    private func saveBookmarks() {
        if let encoded = try? JSONEncoder().encode(bookmarkedPosts) {
            UserDefaults.standard.set(encoded, forKey: bookmarkKey)
        }
    }
    
    private func loadBookmarks() {
        guard let data = UserDefaults.standard.data(forKey: bookmarkKey),
              let decodedPosts = try? JSONDecoder().decode([Post].self, from: data) else {
            return
        }
        bookmarkedPosts = decodedPosts
    }
}
