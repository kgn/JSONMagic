# JSONMagic

`JSONMagic` makes it easy to traverse and parse JSON in Swift.

[![Swift 3](http://img.shields.io/badge/Swift-3-orange.svg)]()
[![Release](https://img.shields.io/github/release/kgn/JSONMagic.svg)](/releases)
[![License](http://img.shields.io/badge/License-MIT-lightgrey.svg)](/LICENSE)

[![Build Status](https://travis-ci.org/kgn/JSONMagic.svg)](https://travis-ci.org/kgn/JSONMagic)
[![Test Coverage](http://img.shields.io/badge/Tests-100%25-green.svg)]()
[![Carthage Compatible](https://img.shields.io/badge/Carthage-Compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/JSONMagic.svg)](https://cocoapods.org/pods/JSONMagic)
[![CocoaPods Platforms](https://img.shields.io/cocoapods/p/JSONMagic.svg)](https://cocoapods.org/pods/JSONMagic)

[![Twitter](https://img.shields.io/badge/Twitter-@iamkgn-55ACEE.svg)](http://twitter.com/iamkgn)
[![Follow](https://img.shields.io/github/followers/kgn.svg?style=social&label=Follow%20%40kgn)](https://github.com/kgn)
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

## Examples

Lets say you get a JSON user profile like this from your server:

``` json
{
    "user": {
        "name": "David Keegan",
        "age": 30,
        "accounts": [
            {
                "name": "twitter",
                "user": "iamkgn"
            },
            {
                "name": "dribbble",
                "user": "kgn"
            },
            {
                "name": "github",
                "user": "kgn"
            }
        ]
    }
}
```

Parsing this can take a bunch of nested if statements in Swift to cast things to the right type in order to traverse down the data tree.

### Before

``` Swift
let twitterUser: String?
if let data = serverResponse {
    if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: Any] {
        if let user = json?["user"] as? [String: Any] {
            if let accounts = user["accounts"] as? [Any] {
                if let twitter = accounts.first as? [String: Any] {
                    twitterUser = twitter["user"] as? String
                }
            }
        }
    }
}
```

### After

``` Swift
let twitterUser = JSONMagic(data: serverResponse).get("user").get("accounts").first.get("user").string
```

Or, if you prefer subscripting :)

``` Swift
let twitterUser = JSONMagic(data: serverResponse)["user"]["accounts"][0]["user"].string
```

`JSONMagic` handles all of this for you with method chaining. So you’re always working with a magical wrapper `JSONMagic` object that you can chain as long as you want, then just call `value` at the end to get the ending value and cast that to the final type you want.

It’s super *loosie goosie* so doesn’t care about `nil` values going in, or anywhere in the chain.

### Some more examples

``` Swift
let json = JSONMagic(data: serverResponse)

json.get("user").get("name").string // David Keegan
json["user"]["age"].integer // 30

let twitter = json.get("user").get("accounts").first
twitter["name"].value // twitter
twitter["user"].value // iamkgn

let dribbble = json.get("user").get("accounts").get(1)
dribbble.get("name").value // dribbble
dribbble.get("user").value // kgn

let github = json.get("user").get("accounts").last
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
- [X] AppleTV
- [X] AppleWatch
- [X] Prebuilt Frameworks
- [ ] Travis Test Matrix
