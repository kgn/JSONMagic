# JSONMagic

`JSONMagic` makes it easy to traverse and parse JSON in Swift.

[![iOS 8.0+](http://img.shields.io/badge/iOS-8.0%2B-blue.svg)]()
[![watchOS 1.0+](http://img.shields.io/badge/watchOS-1.0%2B-blue.svg)]()
[![Xcode 7.1](http://img.shields.io/badge/Xcode-7.0-blue.svg)]()
[![Swift 2.0](http://img.shields.io/badge/Swift-2.0-blue.svg)]()
[![Release](https://img.shields.io/github/release/kgn/JSONMagic.svg)](/releases)
[![Build Status](http://img.shields.io/badge/License-MIT-lightgrey.svg)](/LICENSE)

[![Build Status](https://travis-ci.org/kgn/JSONMagic.svg)](https://travis-ci.org/kgn/JSONMagic)
[![Test Coverage](http://img.shields.io/badge/Tests-100%25-green.svg)]()
[![Carthage Compatible](https://img.shields.io/badge/Carthage-Compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/JSONMagic.svg)](https://cocoapods.org/pods/JSONMagic)
[![CocoaPods Platforms](https://img.shields.io/cocoapods/p/JSONMagic.svg)](https://cocoapods.org/pods/JSONMagic)

[![Twitter](https://img.shields.io/badge/Twitter-@iamkgn-55ACEE.svg)](http://twitter.com/iamkgn)
[![Star](https://img.shields.io/github/followers/kgn.svg?style=social&label=Follow%20%40kgn)](https://github.com/kgn)
[![Star](https://img.shields.io/github/stars/kgn/JSONMagic.svg?style=social&label=Star)](https://github.com/kgn/JSONMagic)

## Installing

### Carthage
```
github "kgn/JSONMagic"
```

### CocoaPods
```
pod 'JSONMagic'
```

## Example

``` Swift
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

let jsonData = try? NSJSONSerialization.dataWithJSONObject(data, options: [])
let json = JSONMagic(data: jsonData!)

json.get("user").get("name").value // David Keegan
json.get("user").get("age").value // 30

let twitter = json.get("user").get("accounts").first()
twitter.get("name").value // twitter
twitter.get("user").value // iamkgn

let dribbble = json.get("user").get("accounts").get(1)
dribbble.get("name").value // dribbble
dribbble.get("user").value // kgn

let github = json.get("user").get("accounts").last()
github.get("name").value // github
github.get("user").value // kgn

let bad = json.get("user").get("accounts").get(5)
bad.get("name").value // nil
bad.get("user").value // nil
```

## Progress
- [X] Badges
- [X] Tests
- [X] Travis
- [X] Carthage
- [X] CocoaPods
- [X] Description
- [X] Documentation
