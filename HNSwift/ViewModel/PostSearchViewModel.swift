import SwiftUI

class PostSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var originalPosts: [Post] = []
    @Published var filteredPosts: [Post] = []
    
    func updatePosts(_ posts: [Post]) {
        self.originalPosts = posts
        self.filterPosts()
    }
    
    func filterPosts() {
        if searchText.isEmpty {
            filteredPosts = originalPosts
        } else {
            filteredPosts = originalPosts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
