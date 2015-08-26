//
//  DictionaryBuilder.swift
//  SwiftBenchmarking
//
//  Created by Maximilian Clarke on 26/08/2015.
//  Copyright (c) 2015 Maximilian Clarke. All rights reserved.
//

import Foundation

struct DictionaryBuilder {
    
    /*
    Build a sizable Swift Dictionary with defined test keys at beginning, middle and end. Uses NSUUID to generate
    random unique strings for filler keys and values.
    */
    func buildShallowSwiftDictionary() -> [String: String] {
        var swDict = [String: String]()
        swDict["Test1"] = "Test1"
        for _ in 0...100 {
            swDict[NSUUID().UUIDString] = NSUUID().UUIDString
        }
        swDict["Test2"] = "Test2"
        for _ in 0...100 {
            swDict[NSUUID().UUIDString] = NSUUID().UUIDString
        }
        swDict["Test3"] = "Test3"
        let immutableDict = swDict
        return immutableDict
    }
    
    /*
    Build a sizable NSDictionary with defined test keys at beginning, middle and end. Uses NSUUID to generate
    random unique strings for filler keys and values.
    */
    func buildShallowNSDictionary() -> NSDictionary {
        var mutableDict = NSMutableDictionary()
        mutableDict["Test1"] = "Test1"
        for _ in 0...100 {
            mutableDict[NSUUID().UUIDString] = NSUUID().UUIDString
        }
        mutableDict["Test2"] = "Test2"
        for _ in 0...100 {
            mutableDict[NSUUID().UUIDString] = NSUUID().UUIDString
        }
        mutableDict["Test3"] = "Test3"
        return NSDictionary(dictionary: mutableDict)
    }
    
    // TODO: Parameterise builder functions to allow easy test running of smaller and larger dictionaries
    
//    func buildNSDictionary(totalKeyCount: Int, testKeyCount: Int, testKeyPrefix: String) -> NSDictionary {}
    
    // TODO: Create builder functions for testable nested Dictionaries, Arrays and combinations of both
}