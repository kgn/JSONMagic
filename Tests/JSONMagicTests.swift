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
        let value = self.json.get("user").get("name").value as? String
        XCTAssertEqual(value, "David Keegan")
        XCTAssertEqual(value, self.json["user"]["name"].value as? String)
    }

    func testInt() {
        let value = self.json.get("user").get("age").value as? Int
        XCTAssertEqual(value, 30)
        XCTAssertEqual(value, self.json["user"]["age"].value as? Int)
    }

    func testFirst() {
        let twitter = self.json.get("user").get("accounts").first
        XCTAssertEqual(twitter.value as? String, self.json["user"]["accounts"][0].value as? String)
        XCTAssertEqual(twitter.get("name").value as? String, "twitter")
        XCTAssertEqual(twitter.get("user").value as? String, "iamkgn")
    }

    func testLast() {
        let github = json.get("user").get("accounts").last
        XCTAssertEqual(github.value as? String, self.json["user"]["accounts"][-1].value as? String)
        XCTAssertEqual(github.get("name").value as? String, "github")
        XCTAssertEqual(github.get("user").value as? String, "kgn")
    }

    func testIndex() {
        let dribbble = json.get("user").get("accounts").get(1)
        XCTAssertEqual(dribbble.value as? String, self.json["user"]["accounts"][1].value as? String)
        XCTAssertEqual(dribbble.get("name").value as? String, "dribbble")
        XCTAssertEqual(dribbble.get("user").value as? String, "kgn")
    }

    func testIndexNil() {
        let bad = json.get("user").get("accounts").get(5)
        XCTAssertNil(json["user"]["accounts"][5]["name"].value)
        XCTAssertNil(bad.get("name").value)
        XCTAssertNil(bad.get("user").value)
    }
    
}
