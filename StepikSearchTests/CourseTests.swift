//
//  CourseTest.swift
//  StepikSearchTests
//
//  Created by Ivan Magda on 06/05/2018.
//  Copyright © 2018 Ivan Magda. All rights reserved.
//

import XCTest
@testable import StepikSearch

class CourseTests: XCTestCase {

    var TOEFL: Course!
    var pythonProgramming: Course!
    var cppProgramming: Course!
    
    override func setUp() {
        super.setUp()

        TOEFL = Course(
            id: 43560730,
            score: 248.3656,
            title: "TOEFL vocabulary",
            coverUrl: "https://stepik.org/media/cache/images/courses/3150/cover/da674dcb4bf280cdbc722214cc86fe93.png"
        )

        pythonProgramming = Course(
            id: 43560731,
            score: 203.29063,
            title: "Программирование на Python",
            coverUrl: "https://stepik.org/media/cache/images/courses/67/cover/cf7621ccee379e4bf27d7cd6927adf2a.png"
        )

        cppProgramming = Course(
            id: 43560734,
            score: 177.39662,
            title: "Введение в программирование (C++)",
            coverUrl: "https://stepik.org/media/cache/images/courses/363/cover/c0e235513f7598d01f96ccc8a27c25a5.jpg"
        )
    }
    
    override func tearDown() {
        super.tearDown()
        TOEFL = nil
        pythonProgramming = nil
        cppProgramming = nil
    }
    
    func testUniqueIds() {
        let ids = [TOEFL, pythonProgramming, cppProgramming].map { $0!.id }
        var prev: Int?

        for id in ids.sorted() {
            if prev == id {
                XCTFail()
            }
            prev = id
        }
    }
    
}
