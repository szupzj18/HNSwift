// HNSwiftTests/PostTests.swift

import XCTest
@testable import HNSwift

final class PostTests: XCTestCase {

    func testPostInitialization() {
        let post = Post(id: 123, title: "Test Title", by: "Test Author", time: 1698765432, text: "Test Text", url: "https://example.com", score: 100, descendants: 5, kids: [1, 2, 3])

        XCTAssertEqual(post.id, 123)
        XCTAssertEqual(post.title, "Test Title")
        XCTAssertEqual(post.by, "Test Author")
        XCTAssertEqual(post.time, 1698765432)
        XCTAssertEqual(post.text, "Test Text")
        XCTAssertEqual(post.url, "https://example.com")
        XCTAssertEqual(post.score, 100)
        XCTAssertEqual(post.descendants, 5)
        XCTAssertEqual(post.kids, [1, 2, 3])
    }

    func testPostDateConversion() {
        let post = Post(id: 123, title: "Test Title", by: "Test Author", time: 1698765432, text: nil, url: nil, score: 0, descendants: nil, kids: nil)
        let expectedDate = Date(timeIntervalSince1970: 1698765432)

        XCTAssertEqual(post.date, expectedDate)
    }

    func testPostMobileURL() {
        let post = Post(id: 123, title: "Test Title", by: "Test Author", time: 1698765432, text: nil, url: nil, score: 0, descendants: nil, kids: nil)
        let expectedURL = URL(string: "https://news.ycombinator.com/item?id=123")

        XCTAssertEqual(post.mobileURL, expectedURL)
    }
}