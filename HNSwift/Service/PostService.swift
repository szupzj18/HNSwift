//
//  PostService.swift
//  HNSwift
//
//  Created by ByteDance on 2024/11/1.
//

import Foundation

enum PostType {
    case top
    case show
}

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
    func fetchPosts(for type: PostType) async throws -> [Post] {
        var postIds: ArraySlice<Int> = []
        switch type {
        case .top:
            postIds = try await self.fetchTopStoryIDs().prefix(10)
        case .show:
            postIds = try await self.fetchShowStoryIDs().prefix(10)
        }
        
        return try await withThrowingTaskGroup(of: Post?.self) { group in
            var posts : [Post] = []
            for id in postIds {
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
    
    func fetchPostDetail(for postID: Int) async throws -> Post {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(postID).json") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let post = try JSONDecoder().decode(Post.self, from: data)

        return post
    }
    
    func fetchShowStoryIDs() async throws -> [Int] {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/showstories.json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let postIds = try JSONDecoder().decode([Int].self, from: data)
        return postIds
    }
    
    func fetchShowStoryDetail(for postID: Int) async throws -> Post {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(postID).json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let post = try JSONDecoder().decode(Post.self, from: data)
        return post
    }
            
}
