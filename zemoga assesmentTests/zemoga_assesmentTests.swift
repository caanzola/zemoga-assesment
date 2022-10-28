//
//  zemoga_assesmentTests.swift
//  zemoga assesmentTests
//
//  Created by Camilo Anzola on 10/24/22.
//

import XCTest
@testable import zemoga_assesment

class zemoga_assesmentTests: XCTestCase {
    
    var app = ViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        // Test posts
        app.loadPosts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.app.posts!.count > 0, "Posts should not be empty, something wrong loading the posts ")
        }
        
        // Test authors
        for post in self.app.posts!{
            app.loadAuthor(idAuthor: post.userId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertTrue(self.app.authorResponse != nil, "Author should not be nil, something wrong loading the author information")
            }
        }
        
        // Test comments
        for post in self.app.posts!{
            app.loadComments(postId: post.id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertTrue(self.app.comments!.count > 0, "Comments should not be empty, something wrong loading the comments")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
