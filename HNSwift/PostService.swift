//
//  PostService.swift
//  HNSwift
//
//  Created by ByteDance on 2024/11/1.
//

import Foundation

struct PostService {
    // 从 Hacker News API 获取数据
    func fetchTopStoryIDs() async throws -> [Int] {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let postIds = try JSONDecoder().decode([Int].self, from: data)
        return postIds
    }
    
    // fetch top 10
    func fetchPosts() async throws -> [Post] {
        let ids = try await self.fetchTopStoryIDs().prefix(10)
        return try await withThrowingTaskGroup(of: Post?.self) { group in
            var posts : [Post] = []
            for id in ids {
                group.addTask {
                    try await self.fetchPostDetail(for: id)
                }
            }
            
            for try await post in group {
                if let post = post {
                    posts.append(post)
                }
            }
            return posts
        }
    
    }
    
    // 获取每个帖子的详细信息
    func fetchPostDetail(for postID: Int) async throws -> Post {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(postID).json") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let post = try JSONDecoder().decode(Post.self, from: data)

        return post
    }
    
//    func fetchPostDetails(for postIDs: ArraySlice<Int>, completion: @escaping ([Post]?) -> Void) {
//        let group = DispatchGroup()
//        var fetchedPosts: [Post] = []
//
//        for id in postIDs {
//            group.enter()
//            guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json") else { continue }
//
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    do {
//                        let post = try JSONDecoder().decode(Post.self, from: data)
//                        fetchedPosts.append(post)
//                    } catch {
//                        print("Error decoding post: \(error)")
//                    }
//                }
//                group.leave()
//            }.resume()
//        }
//
//        group.notify(queue: .main) {
//            completion(fetchedPosts)
//        }
//    }
}
