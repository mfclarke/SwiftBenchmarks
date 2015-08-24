//
//  DictionaryBenchmarker.swift
//  Benchmarking
//
//  Created by Maximilian Clarke on 23/08/2015.
//  Copyright (c) 2015 Maximilian Clarke. All rights reserved.
//

import Foundation

// MARK: Dictionary construction
// 2 identical dictionaries: one NSDictionary, one Swift Dictionary

let metadata1 = NSDictionary(objectsAndKeys:
    "John McTiernan", "Director",
    "40 Stories of Sheer Adventure!", "TagLine"
)
let metadata2 = NSDictionary(objectsAndKeys:
    "Renny Harlin", "Director",
    "Die Harder.", "TagLine"
)
let metadata3 = NSDictionary(objectsAndKeys:
    "John McTiernan", "Director",
    "Fun with a vengeance!", "TagLine"
)
let metadata4 = NSDictionary(objectsAndKeys:
    "Len Wiseman", "Director",
    "", "TagLine"
)
let movies = NSDictionary(objectsAndKeys:
    metadata1, "Die Hard",
    metadata2, "Die Hard 2",
    metadata3, "Die Hard 3",
    metadata4, "Die Hard 4"
)
let mediaTypes = NSDictionary(objectsAndKeys: movies, "Movies")
let nsDict = NSDictionary(objectsAndKeys: mediaTypes, "MediaTypes")


let swMetadata1 = [
    "Director": "John McTiernan",
    "TagLine": "40 Stories of Sheer Adventure!"
]
let swMetadata2 = [
    "Director": "Renny Harlin",
    "TagLine": "Die Harder."
]
let swMetadata3 = [
    "Director": "John McTiernan",
    "TagLine": "Fun with a vengeance!"
]
let swMetadata4 = [
    "Director": "Len Wiseman",
    "TagLine": ""
]
let swMovies = [
    "Die Hard": swMetadata1,
    "Die Hard 2": swMetadata2,
    "Die Hard 3": swMetadata3,
    "Die Hard 4": swMetadata4
]
let swMediaTypes = ["Movies": swMovies]
var swDict = ["MediaTypes": swMediaTypes]



class DictionaryBenchmarker {
    
    // MARK: Methods to benchmark
    
    typealias DictionaryFetcher = () -> AnyObject?
    
    let swiftCastingIfLet: DictionaryFetcher = {
        if let theMediaTypes = nsDict["MediaTypes"] as? [String: AnyObject],
            theMovies = theMediaTypes["Movies"] as? [String: AnyObject],
            metadata = theMovies["Die Hard 2"] as? [String: AnyObject],
            tagline = metadata["TagLine"] as? String {
                return tagline
        }
        return nil
    }
    
    let nsDictionaryIfLet: DictionaryFetcher = {
        if let theMediaTypes = nsDict["MediaTypes"] as? NSDictionary,
            theMovies = theMediaTypes["Movies"] as? NSDictionary,
            metadata = theMovies["Die Hard 2"] as? NSDictionary,
            tagline = metadata["TagLine"] as? String {
                return tagline
        }
        return nil
    }
    
    let swiftIfLet: DictionaryFetcher = {
        if let theMediaTypes = swDict["MediaTypes"],
            theMovies = theMediaTypes["Movies"],
            metadata = theMovies["Die Hard 2"],
            tagline = metadata["TagLine"] {
                return tagline
        }
        return nil
    }
    
    let nsDictionaryOptionalChain: DictionaryFetcher = {
        return ((((nsDict["MediaTypes"] as? NSDictionary)?["Movies"] as? NSDictionary)?["Die Hard 2"] as? NSDictionary)?["TagLine"]) as? String
    }
    
    let swiftOptionalChain: DictionaryFetcher = {
        return swDict["MediaTypes"]?["Movies"]?["Die Hard 2"]?["TagLine"]
    }
    
    let nsDictionaryValueForKeyPath: DictionaryFetcher = {
        return nsDict.valueForKeyPath("MediaTypes.Movies.Die Hard 2.TagLine") as? String
    }
    
    let shallowNSDictionaryValue: DictionaryFetcher = {
        return nsDict["MediaTypes"]
    }
    
    let shallowSwiftDictionaryValue: DictionaryFetcher = {
        return swDict["MediaTypes"]
    }
    
    
    // MARK: Benchmark functions
    
    func benchmarkDictionaryFetch(repeats: Int, dictionaryFetcher: DictionaryFetcher) -> NSTimeInterval {
        let startDate = NSDate()
        var valueFetched: AnyObject?
        for var x=0; x<repeats; x++ {
            valueFetched = dictionaryFetcher()
        }
        assert(valueFetched != nil, "No value fetched, benchmark failed")
        return NSDate().timeIntervalSinceDate(startDate)
    }
    
    func comparisonString(baseline: NSTimeInterval, _ benchmark: NSTimeInterval) -> String {
        let difference = baseline / benchmark
        if difference > 1 {
            return String(format: "%.2f%% faster", (difference - 1) * 100)
        } else if difference < 1 {
            return String(format: "%.2f%% slower", (1 - difference) * 100)
        } else {
            return "equal"
        }
    }
    
    
    // MARK: Benchmark runner
    
    func benchmark() {
        let repeats = 20000
        
        // Benchmark and store times
        
        let nsDictIfLetTime = benchmarkDictionaryFetch(repeats, dictionaryFetcher: nsDictionaryIfLet)
        print(".")
        let swCastingIfLetTime = benchmarkDictionaryFetch(repeats, dictionaryFetcher: swiftCastingIfLet)
        print(".")
        let nsDictOptionalChainTime = benchmarkDictionaryFetch(repeats, dictionaryFetcher: nsDictionaryOptionalChain)
        print(".")
        let swIfLetTime = benchmarkDictionaryFetch(repeats, dictionaryFetcher: swiftIfLet)
        print(".")
        let swOptionalChainTime = benchmarkDictionaryFetch(repeats, dictionaryFetcher: swiftOptionalChain)
        print(".")
        let nsDictValueForKeyPathTime = benchmarkDictionaryFetch(repeats, dictionaryFetcher: nsDictionaryValueForKeyPath)
        print(".")
        let shallowNSDictValueTime = benchmarkDictionaryFetch(repeats, dictionaryFetcher: shallowNSDictionaryValue)
        print(".")
        let shallowSwiftDictValueTime = benchmarkDictionaryFetch(repeats, dictionaryFetcher: shallowSwiftDictionaryValue)
        print(".")
        
        println()
        println()
        
        // Print comparisons
        // Change the below 2 lines to compare against different methods
        
        println("Compared to pure NSDict if/let:")
        let baseline = nsDictIfLetTime
        
        println("NSDict if/let is " + comparisonString(baseline, nsDictIfLetTime))
        println("NSDict cast to Swift Dict if/let is " + comparisonString(baseline, swCastingIfLetTime))
        println("NSDictionary optional chain is " + comparisonString(baseline, nsDictOptionalChainTime))
        println("Pure Swift if/let is " + comparisonString(baseline, swIfLetTime))
        println("Pure Swift optional chain is " + comparisonString(baseline, swOptionalChainTime))
        println("NSDict valueForKeyPath is " + comparisonString(baseline, nsDictValueForKeyPathTime))
        
        println()
        
        println("Compared to shallow NSDictionary value:")
        println("Shallow Swift Dictionary value is " + comparisonString(shallowNSDictValueTime, shallowSwiftDictValueTime))
        
        println()
    }
}
