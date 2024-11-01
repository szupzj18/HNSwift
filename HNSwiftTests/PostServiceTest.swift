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
}
