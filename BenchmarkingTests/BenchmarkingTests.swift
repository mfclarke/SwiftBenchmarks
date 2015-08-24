//
//  BenchmarkingTests.swift
//  BenchmarkingTests
//
//  Created by Maximilian Clarke on 23/08/2015.
//  Copyright (c) 2015 Maximilian Clarke. All rights reserved.
//

import UIKit
import XCTest

let nsDict = NSDictionary(
    object: NSDictionary(
        object: NSDictionary(
            object: NSDictionary(
                object: "Die Harder.",
                forKey: "TagLine"),
            forKey: "Die Hard 2"),
        forKey: "Movies"),
    forKey: "MediaTypes"
)

let swDict = ["MediaTypes": ["Movies": ["Die Hard 2": ["TagLine": "Die Harder."]]]]

class BenchmarkingTests: XCTestCase {
    
    let repeats = 10000
    
    func testSwiftCastingIfLet() {
        self.measureBlock() {
            for _ in 0...self.repeats {
                if let theMediaTypes = nsDict["MediaTypes"] as? [String: AnyObject],
                    theMovies = theMediaTypes["Movies"] as? [String: AnyObject],
                    metadata = theMovies["Die Hard 2"] as? [String: AnyObject],
                    tagline = metadata["TagLine"] as? String {
                        tagline
                } else {
                    XCTFail("Value not fetched")
                }
            }
        }
    }
    
    func testNSDictionaryIfLet() {
        self.measureBlock() {
            for _ in 0...self.repeats {
                if let theMediaTypes = nsDict["MediaTypes"] as? NSDictionary,
                    theMovies = theMediaTypes["Movies"] as? NSDictionary,
                    metadata = theMovies["Die Hard 2"] as? NSDictionary,
                    tagline = metadata["TagLine"] as? String {
                        tagline
                } else {
                    XCTFail("Value not fetched")
                }
            }
        }
    }
    
    func testSwiftIfLet() {
        self.measureBlock() {
            for _ in 0...self.repeats {
                if let theMediaTypes = swDict["MediaTypes"],
                    theMovies = theMediaTypes["Movies"],
                    metadata = theMovies["Die Hard 2"],
                    tagline = metadata["TagLine"] {
                        tagline
                } else {
                    XCTFail("Value not fetched")
                }
            }
        }
    }
    
    func testNSDictionaryOptionalChain() {
        self.measureBlock() {
            for _ in 0...self.repeats {
                if let value = ((((nsDict["MediaTypes"] as? NSDictionary)?["Movies"] as? NSDictionary)?["Die Hard 2"] as? NSDictionary)?["TagLine"]) as? String {
                    value
                } else {
                    XCTFail("Value not fetched")
                }
            }
        }
    }
    
    func testSwiftOptionalChain() {
        self.measureBlock() {
            for _ in 0...self.repeats {
                if let value = swDict["MediaTypes"]?["Movies"]?["Die Hard 2"]?["TagLine"] {
                    value
                } else {
                    XCTFail("Value not fetched")
                }
            }
        }
    }
    
    func testNSDictionaryValueForKeyPath() {
        self.measureBlock() {
            for _ in 0...self.repeats {
                if let value = nsDict.valueForKeyPath("MediaTypes.Movies.Die Hard 2.TagLine") as? String {
                    value
                } else {
                    XCTFail("Value not fetched")
                }
            }
        }
    }
    
    func testShallowNSDictionaryValue() {
        self.measureBlock() {
            for _ in 0...self.repeats {
                if let value: AnyObject? = nsDict["MediaTypes"] {
                    value
                } else {
                    XCTFail("Value not fetched")
                }
            }
        }
    }
    
    func testShallowSwiftDictionaryValue() {
        self.measureBlock() {
            for _ in 0...self.repeats {
                if let value = swDict["MediaTypes"] {
                    value
                } else {
                    XCTFail("Value not fetched")
                }
            }
        }
    }

}
