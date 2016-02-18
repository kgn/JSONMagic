//
//  JSONMagicTests.swift
//  JSONMagicTests
//
//  Created by David Keegan on 10/12/15.
//  Copyright © 2015 David Keegan. All rights reserved.
//

import XCTest
@testable import JSONMagic

class JSONMagicTests: XCTestCase {

    let data = [
        "user": [
            "name": "David Keegan",
            "age": 30,
            "accounts": [
                [
                    "name": "twitter",
                    "user": "iamkgn"
                ],
                [
                    "name": "dribbble",
                    "user": "kgn"
                ],
                [
                    "name": "github",
                    "user": "kgn"
                ]
            ]
        ]
    ]

    lazy var json: JSONMagic = {
        let data = try! NSJSONSerialization.dataWithJSONObject(self.data, options: [])
        return JSONMagic(data: data)
    }()

    func testString() {
        XCTAssertEqual(self.json.get("user").get("name").value as? String, "David Keegan")
    }

    func testInt() {
        XCTAssertEqual(self.json.get("user").get("age").value as? Int, 30)
    }

    func testFirst() {
        let twitter = self.json.get("user").get("accounts").first
        XCTAssertEqual(twitter.get("name").value as? String, "twitter")
        XCTAssertEqual(twitter.get("user").value as? String, "iamkgn")
    }

    func testLast() {
        let github = json.get("user").get("accounts").last
        XCTAssertEqual(github.get("name").value as? String, "github")
        XCTAssertEqual(github.get("user").value as? String, "kgn")
    }

    func testIndex() {
        let dribbble = json.get("user").get("accounts").get(1)
        XCTAssertEqual(dribbble.get("name").value as? String, "dribbble")
        XCTAssertEqual(dribbble.get("user").value as? String, "kgn")
    }

    func testIndexNil() {
        let bad = json.get("user").get("accounts").get(5)
        XCTAssertNil(bad.get("name").value)
        XCTAssertNil(bad.get("user").value)
    }
    
}
