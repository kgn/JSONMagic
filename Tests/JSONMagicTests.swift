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
        let value = self.json.get("user").get("name").string
        XCTAssertEqual(value, "David Keegan")
        XCTAssertEqual(value, self.json["user"]["name"].string)
        XCTAssertEqual(value, self.json.keypath("user.name").string)
    }

    func testInt() {
        let value = self.json.get("user").get("age").int
        XCTAssertEqual(value, 30)
        XCTAssertEqual(value, self.json["user"]["age"].integer)
        XCTAssertEqual(value, self.json.keypath("user.age").int)
    }

    func testFirst() {
        let twitter = self.json.get("user").get("accounts").first
        XCTAssertEqual(twitter.get("name").string, "twitter")
        XCTAssertEqual(twitter.get("user").string, "iamkgn")

        XCTAssertEqual(twitter.string, self.json["user"]["accounts"][0].string)
        XCTAssertEqual(self.json.keypath("user.accounts[0].user").string, "iamkgn")
    }

    func testLast() {
        let github = self.json.get("user").get("accounts").last
        XCTAssertEqual(github.get("name").string, "github")
        XCTAssertEqual(github.get("user").string, "kgn")

        XCTAssertEqual(github.string, self.json["user"]["accounts"][-1].string)
        XCTAssertEqual(self.json.keypath("user.accounts[-1].user").string, "kgn")
    }

    func testIndex() {
        let dribbble = self.json.get("user").get("accounts").get(1)
        XCTAssertEqual(dribbble.get("name").string, "dribbble")
        XCTAssertEqual(dribbble.get("user").string, "kgn")

        XCTAssertEqual(dribbble.string, self.json["user"]["accounts"][1].string)
        XCTAssertEqual(self.json.keypath("user.accounts[1].user").string, "kgn")
    }

    func testIndexNil() {
        let bad = self.json.get("user").get("accounts").get(5)
        XCTAssertNil(self.json["user"]["accounts"][5]["name"].value)
        XCTAssertNil(self.json.keypath("user.accounts[5].name").value)
        XCTAssertNil(bad.get("name").value)
        XCTAssertNil(bad.get("user").value)
    }

}
