//
//  JSONMagic.swift
//  JSONMagic
//
//  Created by David Keegan on 2/17/16.
//  Copyright © David Keegan. All rights reserved.
//

// TODO: implment Equatable

public class JSONMagic {

    /// The value of the item
    public let value: AnyObject?

    /// Create an instance with any object
    public init(_ value: AnyObject? = nil) {
        self.value = value
    }

    /// Create an instance with json data
    public convenience init(data: NSData?) {
        if data != nil {
            self.init(try? NSJSONSerialization.JSONObjectWithData(data!, options: []))
        } else {
            self.init()
        }
    }
    
}

// Keypath
extension JSONMagic {

    /// Paw.app style keypaths
    /// Examples:
    /// "company.employees[0].name" <- get the name of the first employee in the company
    /// "company.employees[-1].name" <- get the name of the last employee in the company
    public func keypath(keypath: String) -> JSONMagic {
        var json = self
        for dotPart in keypath.componentsSeparatedByString(".") {
            for bracketPart in dotPart.componentsSeparatedByString("[") {
                if let index = Int(bracketPart.stringByReplacingOccurrencesOfString("]", withString: "")) {
                    json = json.get(index)
                } else if bracketPart.isEmpty == false {
                    json = json.get(bracketPart)
                }
            }
        }
        return json
    }

}

// Get
extension JSONMagic {

    /// Get the item with the key of the collection
    /// For arrays, negative numbers work back from the length of the array,
    /// -1 for example will return the last objexct, -2 the second to last
    public func get<Key: Hashable>(key: Key) -> JSONMagic {
        if let value = self.value as? [Key: AnyObject] {
            return JSONMagic(value[key])
        }

        if let value = self.array {
            if var index = key as? Int {
                if index < 0 {
                    index = value.count+index
                }
                if index >= 0 && index < value.count {
                    return JSONMagic(value[index])
                }
            }
        }

        return JSONMagic()
    }

}

// Value helpers
extension JSONMagic {

    public var int: Int? {
        return self.value as? Int
    }

    public var integer: Int? {
        return self.int
    }

    public var float: Float? {
        return self.value as? Float
    }

    public var double: Double? {
        return self.value as? Double
    }

    public var string: String? {
        return self.value as? String
    }

    public var array: [AnyObject]? {
        return self.value as? [AnyObject]
    }

    // TODO: how to make this work with <Key: Hashable>
//    public var dictionary: [String: AnyObject]? {
//        return self.value as? [String: AnyObject]
//    }

}

// TODO: add generic subscript once it's avalible in Swift 3.0
// https://twitter.com/jckarter/status/700422476510023680

// Subscript
extension JSONMagic {

    /// Wraps `get(key)` allowing you to use `[String]`.
    public subscript(key: String) -> JSONMagic {
        return self.get(key)
    }

    /// Wraps `get(index)` allowing you to use `[Int]`.
    public subscript(index: Int) -> JSONMagic {
        return self.get(index)
    }

}

// First/Last
extension JSONMagic {

    /// Get the first item of the array
    public var first: JSONMagic {
        return self.get(0)
    }

    /// Get the last item of the array
    public var last: JSONMagic {
        return self.get(-1)
    }
    
}
