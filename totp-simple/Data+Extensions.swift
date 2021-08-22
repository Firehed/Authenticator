//
//  Data+Extensions.swift
//  totp-simple
//
//  Created by Eric Stern on 10/5/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import Foundation

extension Data {
    mutating func patch(atByteOffset: Int, withData data: Data) {
        let range = atByteOffset..<(atByteOffset+data.count) as Range<Index>
        replaceSubrange(range, with: data)
    }
}
