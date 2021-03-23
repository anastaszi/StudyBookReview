//
//  StudyBookReviewTests.swift
//  StudyBookReviewTests
//
//  Created by Anastasia Zimina on 3/21/21.
//

import XCTest
@testable import StudyBookReview

class StudyBookReviewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDataModelInitSucceeds() {
        let newReview = ReviewData.init(id: 1, title: "New Book", author: "Adam Smith", review: "Book is great", photo: "image1", rating: 5, userName: "Masha")
        XCTAssertNotNil(newReview);
    }
    
    func testDataModelInitFails() {
        let negativeRating = ReviewData.init(id: 1, title: "New Book", author: "Adam Smith", review: "Book is great", photo: "image1", rating: -1, userName: "Masha");
        XCTAssertNil(negativeRating);
        
        let noReviewRating = ReviewData.init(id: 1, title: "New Book", author: "Adam Smith", review: "", photo: "image1", rating: 4, userName: "Masha");
        XCTAssertNil(noReviewRating);
        
    }

}
