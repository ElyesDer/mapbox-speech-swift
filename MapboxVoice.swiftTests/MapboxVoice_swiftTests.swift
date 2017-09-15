//
//  MapboxVoice_swiftTests.swift
//  MapboxVoice.swiftTests
//
//  Created by Bobby Sudekum on 9/15/17.
//  Copyright © 2017 Mapbox. All rights reserved.
//

import XCTest
@testable import MapboxVoice

class MapboxVoice_swiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let voice = Voice(accessToken: "foo", host: "foo")
        let options = VoiceOptions(text: "foo")
        options.textType = .text
        options.voiceId = .Joanna
        options.outputFormat = .mp3
        
        voice.calculate(options) { (data: Data?, error: NSError?) in
            XCTAssertNil(error)
            
            XCTAssertNotNil(data)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
