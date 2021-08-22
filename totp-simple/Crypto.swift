//
//  Crypto.swift
//  totp-simple
//
//  Created by Eric Stern on 10/5/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import Foundation

struct Crypto {

    enum Algorithm {
        case sha1
        case sha256
        case sha512
        var asCType: CCHmacAlgorithm {
            switch self {
            case .sha1: return CCHmacAlgorithm(kCCHmacAlgSHA1)
            case .sha256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
            case .sha512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
            }
        }
        var length: Int {
            switch self {
            case .sha1: return Int(CC_SHA1_DIGEST_LENGTH)
            case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
            case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }
    }

    static func HMAC(algorithm: Algorithm, data: Data, key: Data) -> Data {
        var key = key
        var data = data
        var output = Data(count: algorithm.length)
        var context = CCHmacContext()
        key.withUnsafeMutableBytes { secretBytes in
            CCHmacInit(&context, algorithm.asCType, secretBytes, key.count)
        }
        data.withUnsafeMutableBytes { dataBytes in
            CCHmacUpdate(&context, dataBytes, data.count)
        }
        output.withUnsafeMutableBytes { outputBytes in
            CCHmacFinal(&context, outputBytes)
        }
        return output
    }
}
