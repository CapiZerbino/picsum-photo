//
//  PhotoModelTests.swift
//  picsumTests
//
//  Created by Tieu Viet Trong Nghia on 26/8/24.
//

import XCTest

final class PhotoModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPhotoModelDecoding() throws {
            let jsonData = """
            [
               {
                   "id": "0",
                   "author": "Alejandro Escamilla",
                   "width": 5000,
                   "height": 3333,
                   "url": "https://unsplash.com/photos/yC-Yzbqy7PY",
                   "download_url": "https://picsum.photos/id/0/5000/3333"
               }
            ]
            """.data(using: .utf8)!
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: jsonData)
                XCTAssertEqual(photos.count, 1)
                XCTAssertEqual(photos[0].id, "0")
                XCTAssertEqual(photos[0].author, "Alejandro Escamilla")
                XCTAssertEqual(photos[0].width, 5000)
                XCTAssertEqual(photos[0].height, 3333)
                XCTAssertEqual(photos[0].url, "https://unsplash.com/photos/yC-Yzbqy7PY")
                XCTAssertEqual(photos[0].download_url, "https://picsum.photos/id/0/5000/3333")
            } catch {
                XCTFail("Decoding error: \(error)")
            }
        }

}
