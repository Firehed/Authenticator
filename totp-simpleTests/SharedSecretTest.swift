//
//  SharedSecretTest.swift
//  totp-simpleTests
//
//  Created by Eric Stern on 10/5/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import XCTest

class SharedSecretTest: XCTestCase {

    let sha1Secret = "12345678901234567890".data(using: .utf8)!
    let sha256Secret = "12345678901234567890123456789012".data(using: .utf8)!
    let sha512Secret = "1234567890123456789012345678901234567890123456789012345678901234".data(using: .utf8)!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testVectorsFromRFC6238() {
        let ss1 = SharedSecret(secret: sha1Secret,
                               algorithm: .sha1,
                               digits: 8)

        let ss256 = SharedSecret(secret: sha256Secret,
                                 algorithm: .sha256,
                                 digits: 8)

        let ss512 = SharedSecret(secret: sha512Secret,
                                 algorithm: .sha512,
                                 digits: 8)

        var testVectors = [(timestamp: TimeInterval,
                            sharedSecret: SharedSecret,
                            output: String)]()

        testVectors.append((59, ss1, "94287082"))
        testVectors.append((59, ss256, "46119246"))
        testVectors.append((59, ss512, "90693936"))

        testVectors.append((1111111109, ss1, "07081804"))
        testVectors.append((1111111109, ss256, "68084774"))
        testVectors.append((1111111109, ss512, "25091201"))

        testVectors.append((1111111111, ss1, "14050471"))
        testVectors.append((1111111111, ss256, "67062674"))
        testVectors.append((1111111111, ss512, "99943326"))

        testVectors.append((1234567890, ss1, "89005924"))
        testVectors.append((1234567890, ss256, "91819424"))
        testVectors.append((1234567890, ss512, "93441116"))

        testVectors.append((2000000000, ss1, "69279037"))
        testVectors.append((2000000000, ss256, "90698825"))
        testVectors.append((2000000000, ss512, "38618901"))

        testVectors.append((20000000000, ss1, "65353130"))
        testVectors.append((20000000000, ss256, "77737706"))
        testVectors.append((20000000000, ss512, "47863826"))

        testVectors.forEach { test in
            let time = Date(timeIntervalSince1970: test.timestamp)
            XCTAssertEqual(test.output, test.sharedSecret.getOTP(at: time))
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
