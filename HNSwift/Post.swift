// https://github.com/HackerNews/API?tab=readme-ov-file
import Foundation

// 定义一个数据模型来表示 HackerNews 的帖子
struct Post: Identifiable, Decodable {
    let id: Int
    let title: String
    let by: String
    let time: Int
    let text: String?
    let url: String?
    let score: Int
    let descendants: Int?
    let kids: [Int]?
    
    // 计算属性，用于将 Unix 时间戳转换为 Date
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(time))
    }
    
    var mobileURL: URL? {
        return URL(string: "https://news.ycombinator.com/item?id=\(id)")
    }
}
