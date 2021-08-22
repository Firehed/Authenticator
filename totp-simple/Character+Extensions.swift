//
//  Character+Extensions.swift
//  totp-simple
//
//  Created by Eric Stern on 10/5/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import Foundation

extension Character {
    var base32Subbyte: Int {
        switch self {
        case "A"..."Z": return Int(unicodeScalars.first!.value) - 65
        case "2"..."7": return Int(unicodeScalars.first!.value) - 24
        default: return 0
        }
    }
}
