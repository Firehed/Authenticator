//
//  Int+Extensions.swift
//  totp-simple
//
//  Created by Eric Stern on 10/5/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import Foundation

extension Int {
    var uint8s: [UInt8] {
        var out: [UInt8] = []
        var i = self
        while i > 0 {
            out.append(UInt8(i & 0xFF))
            i = i >> 8
        }
        return out.reversed()
    }
}
