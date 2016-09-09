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
        let data = try! JSONSerialization.data(withJSONObject: self.data, options: [])
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

class JSONMagicEqualTests: XCTestCase {

    func testBool() {
        XCTAssertEqual(JSONMagic(true), JSONMagic(true))
        XCTAssertEqual(JSONMagic(false), JSONMagic(false))
        XCTAssertNotEqual(JSONMagic(true), JSONMagic(false))
        XCTAssertNotEqual(JSONMagic(false), JSONMagic(true))
        XCTAssertNotEqual(JSONMagic(true), nil)
    }
    
    func testIntiger() {
        XCTAssertEqual(JSONMagic(1), JSONMagic(1))
        XCTAssertEqual(JSONMagic(43), JSONMagic(43))
        XCTAssertNotEqual(JSONMagic(12), JSONMagic(45))
        XCTAssertNotEqual(JSONMagic(65), nil)
    }
    
    func testFloatingPoint() {
        XCTAssertEqual(JSONMagic(1.23), JSONMagic(1.23))
        XCTAssertNotEqual(JSONMagic(43.0), JSONMagic(43))
        XCTAssertNotEqual(JSONMagic(0.12), JSONMagic(0.45))
        XCTAssertNotEqual(JSONMagic(65.54), nil)
    }
    
    func testString() {
        XCTAssertEqual(JSONMagic("dave"), JSONMagic("dave"))
        XCTAssertNotEqual(JSONMagic("dave"), JSONMagic("greg"))
        XCTAssertNotEqual(JSONMagic("dave"), nil)
    }
    
    func testArray() {
        XCTAssertEqual(JSONMagic(["dave", "greg", "matt"]), JSONMagic(["dave", "greg", "matt"]))
        XCTAssertNotEqual(JSONMagic(["dave", "greg", "matt"]), JSONMagic(["eggs", "fish"]))
        
        XCTAssertEqual(JSONMagic([1, 2, 3]), JSONMagic([1, 2, 3]))
        XCTAssertNotEqual(JSONMagic([1, 2, 3]), JSONMagic([4, 5]))
        
        XCTAssertEqual(JSONMagic([1.1, 2.2, 3.3]), JSONMagic([1.1, 2.2, 3.3]))
        XCTAssertNotEqual(JSONMagic([1.1, 2.2, 3.3]), JSONMagic([1.1, 2.2]))
        
        XCTAssertEqual(JSONMagic(["dave", "greg", ["dog", "cat"]]), JSONMagic(["dave", "greg", ["dog", "cat"]]))
        XCTAssertNotEqual(JSONMagic(["dave", "greg", ["dog", "cat"]]), JSONMagic(["dave", "greg"]))
        
        XCTAssertNotEqual(JSONMagic(["girl", "boy"]), nil)
    }
    
    func testDictionary() {
        XCTAssertEqual(JSONMagic(["person1": "dave", "person2": "greg", "person3": "matt"]), JSONMagic(["person1": "dave", "person2": "greg", "person3": "matt"]))
        XCTAssertNotEqual(JSONMagic(["key1": "dave", "key2": "greg", "key3": "matt"]), JSONMagic(["key1": "eggs", "key2": "fish"]))
        
        XCTAssertEqual(JSONMagic(["v1": 1, "v2": 2, "v3": 3]), JSONMagic(["v1": 1, "v2": 2, "v3": 3]))
        XCTAssertNotEqual(JSONMagic(["v1": 1, "v2": 2, "v3": 3]), JSONMagic(["v1": 5, "v2": 6, "v3": 7]))
        
        XCTAssertEqual(JSONMagic(["v1": 1.1, "v2": 2.2, "v3": 3.3]), JSONMagic(["v1": 1.1, "v2": 2.2, "v3": 3.3]))
        XCTAssertNotEqual(JSONMagic(["v1": 1.1, "v2": 2.2, "v3": 3.3]), JSONMagic(["v1": 5.5, "v2": 6.6, "v3": 7.7]))
        
        XCTAssertEqual(JSONMagic(["person1": "dave", "person2": "greg", "people": ["person1": "dave", "person2": "greg", "person3": "matt"]]),
                       JSONMagic(["person1": "dave", "person2": "greg", "people": ["person1": "dave", "person2": "greg", "person3": "matt"]]))
        XCTAssertNotEqual(JSONMagic(["person1": "dave", "person2": "greg", "people": ["person1": "dave", "person2": "greg", "person3": "matt"]]),
                       JSONMagic(["person1": "dave", "person2": "greg", "people": ["item1": "eggs", "item2": "fish"]]))
        
        XCTAssertNotEqual(JSONMagic(["g": "girl", "b": "boy"]), nil)
    }
    
    func testNil() {
        XCTAssertEqual(JSONMagic(), JSONMagic())
        XCTAssertNotEqual(JSONMagic("dave"), nil)
    }
    
}
