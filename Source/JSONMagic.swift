//
//  JSONMagic.swift
//  JSONMagic
//
//  Created by David Keegan on 2/17/16.
//  Copyright © David Keegan. All rights reserved.
//

// TODO: implment Sequence

// TODO: can the values be limited 
// to just these supported JSON ones?
//public protocol JSONValue {}
//extension Bool: JSONValue {}
//extension Int: JSONValue {}
//extension Float: JSONValue {}
//extension Double: JSONValue {}
//extension CGFloat: JSONValue {}
//extension String: JSONValue {}
//extension Array: JSONValue {}
//extension Dictionary: JSONValue {}

public typealias JSONArray = [Any]
public typealias JSONDictionary = [String: Any]

// MARK: -
public struct JSONMagic {

    /// The value of the item
    public let value: Any?
    
    /// Create an instance with any object
    public init(_ value: Any? = nil) {
        self.value = value
    }

    /// Create an instance with json data
    public init(data: Data?) {
        if data != nil {
            self.init(try? JSONSerialization.jsonObject(with: data!, options: []))
        } else {
            self.init()
        }
    }
    
}

// MARK: - Get
extension JSONMagic {

    /// Get the item with a given index, if one exists.
    /// Negative numbers work back from the length of the array,
    /// -1 for example will return the last objexct, -2 the second to last
    public func get(_ index: Int) -> JSONMagic {
        guard let array = self.array, index < array.count else {
            return JSONMagic()
        }
        return JSONMagic(array[index < 0 ? array.count+index : index])
    }
    
    /// Get the item with a given key, if one exists.
    public func get(_ key: String) -> JSONMagic {
        return JSONMagic(self.dictionary?[key])
    }
    
}

// MARK: - Keypath
extension JSONMagic {

    /// Paw.app style keypaths:
    /// "company.employees[0].name" <- get the name of the first employee in the company
    /// "company.employees[-1].name" <- get the name of the last employee in the company
    public func keypath(_ keypath: String) -> JSONMagic {
        var json = self
        for dotPart in keypath.components(separatedBy: ".") {
            for bracketPart in dotPart.components(separatedBy: "[") {
                if let index = Int(bracketPart.replacingOccurrences(of: "]", with: "")) {
                    json = json.get(index)
                } else if bracketPart.isEmpty == false {
                    json = json.get(bracketPart)
                }
            }
        }
        return json
    }

}

// MARK: - Value helpers
extension JSONMagic {

    public var bool: Bool? {
        return self.value as? Bool
    }
    
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

    public var array: JSONArray? {
        return self.value as? JSONArray
    }

    public var dictionary: JSONDictionary? {
        return self.value as? JSONDictionary
    }

}

// MARK: - Subscript
extension JSONMagic {

    /// Subscript for indices
    public subscript(index: Int) -> JSONMagic {
        return self.get(index)
    }

    /// Subscript for keys
    public subscript(key: String) -> JSONMagic {
        return self.get(key)
    }

}

// MARK: - First/Last
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

// MARK: - Description
extension JSONMagic: CustomStringConvertible {
    public var description: String {
        if self.value == nil {
            // TODO: What's the best thing to print?
            return "<No Value>"
        }
        
        return "\(self.value!)"
    }
}

// MARK: - Equatable
extension JSONMagic: Equatable {}
public func ==(lhs: JSONMagic, rhs: JSONMagic) -> Bool {
    let lhv = lhs.value, rhv = rhs.value
    if lhv == nil && rhv == nil {
        return true
    } else if lhv is Bool && rhv is Bool && lhv as? Bool == rhv as? Bool {
        return true
    } else if lhv is Integer && rhv is Integer && lhv as? Int == rhv as? Int {
        return true
    } else if lhv is FloatingPoint && rhv is FloatingPoint && lhv as? Double == rhv as? Double {
        return true
    } else if lhv is String && rhv is String && lhv as? String == rhv as? String {
        return true
    } else if let lha = lhv as? JSONArray, let rha = rhv as? JSONArray {
        return NSArray(array: lha).isEqual(to: rha)
    } else if let lhd = lhv as? JSONDictionary, let rhd = rhv as? JSONDictionary {
        return NSDictionary(dictionary: lhd).isEqual(to: rhd)
    }
    return false
}
