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
    public func get(key: String) -> JSONMagic {
        if let subData = self.value as? NSDictionary {
            return JSONMagic(subData[key])
        }
        return JSONMagic()
    }

    /// Get the item at the index of the array
    public func get(index: Int) -> JSONMagic {
        if let subData = self.value as? NSArray where index < subData.count {
            return JSONMagic(subData[index])
        }
        return JSONMagic()
    }

    /// Get the first item of the array
    public var first: JSONMagic {
        if let subData = self.value as? NSArray {
            return JSONMagic(subData[0])
        }
        return JSONMagic()
    }

    /// Get the last item of the array
    public var last: JSONMagic {
        if let subData = self.value as? NSArray {
            return JSONMagic(subData[subData.count-1])
        }
        return JSONMagic()
    }
    
}
