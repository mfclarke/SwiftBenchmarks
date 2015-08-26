//
//  BenchmarkingTests.swift
//  BenchmarkingTests
//
//  Created by Maximilian Clarke on 23/08/2015.
//  Copyright (c) 2015 Maximilian Clarke. All rights reserved.
//

import UIKit
import XCTest

class BenchmarkingTests: XCTestCase {
    
    let nestedNSDict = NSDictionary(
        object: NSDictionary(
            object: NSDictionary(
                object: NSDictionary(
                    object: "Die Harder.",
                    forKey: "TagLine"),
                forKey: "Die Hard 2"),
            forKey: "Movies"),
        forKey: "MediaTypes"
    )
    
    let nestedSwiftDict: NestedSwiftDictionary = ["MediaTypes": ["Movies": ["Die Hard 2": ["TagLine": "Die Harder."]]]]
    
    
    // MARK: Nested test
    
    func testNestedDictionaryFetchPerformance() {
        let dictionaryFetcher = DictionaryFetcher()
        self.measureBlock() {
            for _ in 0...10000 {
                // Set the basline: run test with this fetch method first and set the result as the baseline
                dictionaryFetcher.fetchFromNSDictionaryWithoutAnyBridgingInIfLetChain(self.nestedNSDict)
        
                // Then comment out the baseline and comment these in one by one to compare
//                dictionaryFetcher.fetchFromNSDictionaryByCastingToSwiftDictInIfLetChain(self.nestedNSDict)
//                dictionaryFetcher.fetchFromSwiftDictionaryWithoutAnyCastingInIfLetChain(self.nestedSwiftDict)
//                dictionaryFetcher.fetchFromNSDictionaryByOptionalChain(self.nestedNSDict)
//                dictionaryFetcher.fetchFromSwiftDictionaryByUsingOptionalChain(self.nestedSwiftDict)
//                dictionaryFetcher.fetchFromNSDictionaryUsingValueForKeyPath(self.nestedNSDict)
            }
        }
    }
    
    
    // MARK: Shallow tests
    
    func testShallowNSDictionaryFetchPerformance() {
        let dictionaryFetcher = DictionaryFetcher()
        let nsDict = DictionaryBuilder().buildShallowNSDictionary()
        
        self.measureBlock() {
            for _ in 0...10000 {
                dictionaryFetcher.shallowFetchFromNSDictionary(nsDict)
            }
        }
    }
    
    func testShallowSwiftDictionaryFetchPerformance() {
        let dictionaryFetcher = DictionaryFetcher()
        let swDict = DictionaryBuilder().buildShallowSwiftDictionary()
        
        self.measureBlock() {
            for _ in 0...10000 {
                dictionaryFetcher.shallowFetchFromSwiftDictionary(swDict)
            }
        }
    }

}
