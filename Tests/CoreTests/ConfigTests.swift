//
//  ConfigTests.swift
//  CoreTests
//
//  Created by Jake Heiser on 9/20/17.
//

import XCTest
import FileKit
@testable import Core

class ConfigTests: XCTestCase {
    
    let configPath = Path("config.json")
    
    override func tearDown() {
        if configPath.exists {
            try! configPath.deleteFile()
        }
    }
    
    func testGet() {
        try! """
        {
          "bin" : "/.icebox/bin",
          "strict" : true
        }
        """.write(to: configPath)
        
        let config = Config(globalConfigPath: configPath)
        XCTAssertEqual(config.get(\.bin), "/.icebox/bin")
        XCTAssertEqual(config.get(\.strict), true)
    }
    
    func testSet() {
        try! """
        {
          "bin" : "/.icebox/bin",
          "strict" : true
        }
        """.write(to: configPath)

        let config = Config(globalConfigPath: configPath)
        try! config.set(\.bin, value: "/my/special/bin")

        
        XCTAssertEqual(try? String.read(from: configPath), """
        {
          "bin" : "\\/my\\/special\\/bin",
          "strict" : true
        }
        """)
        XCTAssertEqual(config.get(\.bin), "/my/special/bin")
        XCTAssertEqual(config.get(\.strict), true)
    }
    
    func testLayer() {
        let top = ConfigFile(
            bin: "/my/bin",
            strict: nil
        )
        let bottom = ConfigFile(
            bin: "/.icebox/bin",
            strict: false
        )
        
        let result = ConfigFile.layer(config: top, onto: bottom)
        XCTAssertEqual(result.bin, "/my/bin")
        XCTAssertEqual(result.strict, false)
    }
    
}
