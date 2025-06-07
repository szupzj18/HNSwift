import XCTest
@testable import HNSwift

final class HNPostServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override class func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        super.tearDown()
    }
    
    func testFetchTopStoryIDs() async throws {
        let mockData = "[1, 2, 3]".data(using: .utf8)
        guard let mockData = mockData else {
            return
        }
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let service = PostService()
        let postIDs = try await service.fetchTopStoryIDs()
        XCTAssertEqual(postIDs, [1, 2, 3])
    }
    
    func testFetchPosts() async throws {
        let post1 = """
        {
            "id": 1,
            "title": "Test Title 1",
            "by": "Test Author 1",
            "time": 1698765432,
            "text": "Test Text 1",
            "url": "https://example.com/1",
            "score": 100,
            "descendants": 5,
            "kids": [1, 2, 3]
        }
        """.data(using: .utf8)!

        let post2 = """
        {
            "id": 2,
            "title": "Test Title 2",
            "by": "Test Author 2",
            "time": 1698765433,
            "text": "Test Text 2",
            "url": "https://example.com/2",
            "score": 101,
            "descendants": 6,
            "kids": [4, 5, 6]
        }
        """.data(using: .utf8)!

        let post3 = """
        {
            "id": 3,
            "title": "Test Title 3",
            "by": "Test Author 3",
            "time": 1698765434,
            "text": "Test Text 3",
            "url": "https://example.com/3",
            "score": 102,
            "descendants": 7,
            "kids": [7, 8, 9]
        }
        """.data(using: .utf8)!

        let postsData: [Int: Data] = [1: post1, 2: post2, 3: post3]

        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                return (HTTPURLResponse(), Data())
            }

            if url.lastPathComponent == "topstories.json" {
                let idsData = "[1,2,3]".data(using: .utf8)!
                return (HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, idsData)
            }

            if url.path.contains("/item/") {
                let idString = url.lastPathComponent.replacingOccurrences(of: ".json", with: "")
                if let id = Int(idString), let data = postsData[id] {
                    return (HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
                }
            }

            return (HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!, Data())
        }
        
        let service = PostService()
        let posts = try await service
            .fetchPosts(for: .top)
        XCTAssertEqual(posts.count, 3)
        XCTAssertEqual(posts.map(\.id), [1, 2, 3])
    }

}
