//
//  String+Extensions.swift
//  totp-simple
//
//  Created by Eric Stern on 10/5/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import Foundation

extension String {
    func base32Decode() -> Data {
        var d = Data(count: (5 * count / 8))
        split(chunkSize: 8).enumerated().forEach { offset, chunk in
            let bits = chunk
                .map { $0.base32Subbyte }
                .enumerated()
                .reduce(0) { sum, element in
                    let (i, value) = element
                    let sl = 5 * (7 - i)
                    return sum + (value << sl)
            }

            let subdata = Data(bits.uint8s)
            d.patch(atByteOffset: 5 * offset, withData: subdata)
        }

        return d
    }

    func split(chunkSize: Int) -> [String] {
        return stride(from: 0, to: count, by: chunkSize).map { i in
            let max = (i + chunkSize-1 >= characters.count) ? characters.count - 1 : i + chunkSize-1
            return self[i...max]
        }
    }

    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[startIndex...endIndex])
        }
    }
}
