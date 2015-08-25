//
//  DictionaryFetcher.swift
//  Benchmarking
//
//  Created by Maximilian Clarke on 25/08/2015.
//  Copyright (c) 2015 Maximilian Clarke. All rights reserved.
//

import Foundation

// Strongly typing the dictionary structure to let Swift's compiler fully optimise
typealias MoviesDictionary = [String: [String: [String: [String: String]]]]

// MARK: Nested Fetch Methods

class DictionaryFetcher {
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
    func fetchFromSwiftDictionaryWithoutAnyCastingInIfLetChain(swDict: MoviesDictionary) -> String {
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
    func fetchFromSwiftDictionaryByUsingOptionalChain(swDict: MoviesDictionary) -> String {
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

// MARK: Shallow Fetch Methods

extension DictionaryFetcher {
    /**
    Simple subscript single value fetch from NSDictionary
    */
    func shallowFetchFromNSDictionary(nsDict: NSDictionary) -> AnyObject {
        if let mediaTypes: AnyObject = nsDict["MediaTypes"] {
            return mediaTypes
        }
        fatalError("Value not fetched")
    }
    
    /**
    Simple subscript single value fetch from Swift Dictionary
    */
    func shallowFetchFromSwiftDictionary(swDict: MoviesDictionary) -> AnyObject {
        if let mediaTypes = swDict["MediaTypes"] {
            return mediaTypes
        }
        fatalError("Value not fetched")
    }
    
}
