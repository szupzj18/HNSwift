import XCTest
@testable import HNSwift

final class HNPostServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override class func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
}
