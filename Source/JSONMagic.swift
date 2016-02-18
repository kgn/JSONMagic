//
//  JSONMagic.swift
//  JSONMagic
//
//  Created by David Keegan on 2/17/16.
//  Copyright © David Keegan. All rights reserved.
//

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

    /// Get the item with the key of the dictionary
    public func get<Key: Hashable>(key: Key) -> JSONMagic {
        if let subData = self.value as? [Key: AnyObject] {
            return JSONMagic(subData[key])
        }
        return JSONMagic()
    }

    /// Wraps `get(key)` allowing you to use `[Key]`.
    public subscript(key: Key) -> JSONMagic {
        return self.get(key)
    }

    /// Get the item at the index of the array
    /// Negative values work back from teh length of the array,
    /// -1 for example will return the last objexct, -2 the second to last
    public func get(index: Int) -> JSONMagic {
        if let subData = self.value as? [AnyObject] where index < subData.count {
            return JSONMagic(subData[index])
        }
        return JSONMagic()
    }

    /// Wraps `get(index)` allowing you to use `[Int]`.
    public subscript(index: Int) -> JSONMagic {
        return self.get(index)
    }

    /// Get the first item of the array
    public var first: JSONMagic {
        return self.get(0)
    }

    /// Get the last item of the array
    public var last: JSONMagic {
        return self.get(-1)
    }
    
}
