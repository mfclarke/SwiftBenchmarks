//
//  DictionaryFetcher.swift
//  Benchmarking
//
//  Created by Maximilian Clarke on 25/08/2015.
//  Copyright (c) 2015 Maximilian Clarke. All rights reserved.
//

import Foundation

// Strongly typing the dictionary structure to let Swift's compiler fully optimise
typealias NestedSwiftDictionary = [String: [String: [String: [String: String]]]]

// MARK: Shallow Fetch Methods

class DictionaryFetcher {
    
    /**
    Simple subscript single value fetch from NSDictionary
    */
    func shallowFetchFromNSDictionary(nsDict: NSDictionary) -> AnyObject {
        if let value1: AnyObject = nsDict["Test1"] {
            if let value2: AnyObject = nsDict["Test2"] {
                if let value3: AnyObject = nsDict["Test3"] {
                    return value3
                }
            }
        }
        fatalError("Value not fetched")
    }
    
    /**
    Simple subscript single value fetch from Swift Dictionary
    */
    func shallowFetchFromSwiftDictionary(swDict: [String: String]) -> AnyObject {
        if let value1 = swDict["Test1"] {
            if let value2 = swDict["Test2"] {
                if let value3 = swDict["Test3"] {
                    return value3
                }
            }
        }
        fatalError("Value not fetched")
    }
    
}


// MARK: Nested Fetch Methods

extension DictionaryFetcher {
    
    /**
    Pure NSDictionary the whole way, with no briding to Swift until the final value.
    */
    func fetchFromNSDictionaryWithoutAnyBridgingInIfLetChain(nsDict: NSDictionary) -> String {
        if let mediaTypes = nsDict["MediaTypes"] as? NSDictionary,
            movies = mediaTypes["Movies"] as? NSDictionary,
            metadata = movies["Die Hard 2"] as? NSDictionary,
            tagline = metadata["TagLine"] as? NSString {
                return tagline as String
        }
        fatalError("Value not fetched")
    }
    
    /**
    Bridging to Swift every step of the way. I did this in a project once naively thinking this would
    take full advantage of Swift's Swiftiness.
    */
    func fetchFromNSDictionaryByCastingToSwiftDictInIfLetChain(nsDict: NSDictionary) -> String {
        if let mediaTypes = nsDict["MediaTypes"] as? [String: AnyObject],
            movies = mediaTypes["Movies"] as? [String: AnyObject],
            metadata = movies["Die Hard 2"] as? [String: AnyObject],
            tagline = metadata["TagLine"] as? String {
                return tagline
        }
        fatalError("Value not fetched")
    }
    
    /**
    Pure strongly typed Swift Dictionary. No bridging or optional casting.
    */
    func fetchFromSwiftDictionaryWithoutAnyCastingInIfLetChain(swDict: NestedSwiftDictionary) -> String {
        if let mediaTypes = swDict["MediaTypes"],
            movies = mediaTypes["Movies"],
            metadata = movies["Die Hard 2"],
            tagline = metadata["TagLine"] {
                return tagline
        }
        fatalError("Value not fetched")
    }
    
    /**
    Instead of using a chained if/let, use a long ugly optional chain with optional casting compiler hints
    */
    func fetchFromNSDictionaryByOptionalChain(nsDict: NSDictionary) -> String {
        if let value = ((((nsDict["MediaTypes"] as? NSDictionary)?["Movies"] as? NSDictionary)?["Die Hard 2"] as? NSDictionary)?["TagLine"]) as? NSString {
            return value as String
        }
        fatalError("Value not fetched")
    }
    
    /**
    Pure Swift strongy typed optional chain
    */
    func fetchFromSwiftDictionaryByUsingOptionalChain(swDict: NestedSwiftDictionary) -> String {
        if let value = swDict["MediaTypes"]?["Movies"]?["Die Hard 2"]?["TagLine"] {
            return value
        }
        fatalError("Value not fetched")
    }
    
    /**
    NSDictionary's handy valueForKeyPath method
    */
    func fetchFromNSDictionaryUsingValueForKeyPath(nsDict: NSDictionary) -> String {
        if let value = nsDict.valueForKeyPath("MediaTypes.Movies.Die Hard 2.TagLine") as? String {
            return value
        }
        fatalError("Value not fetched")
    }
    
}
