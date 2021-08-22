//
//  SharedSecret.swift
//  totp-simple
//
//  Created by Eric Stern on 10/2/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import Foundation

struct SharedSecret {

    enum SecretType {
        case hotp
        case totp
    }

    let algorithm: Crypto.Algorithm
    let counter: Int
    let digits: Int8
    let issuer: String
    let label: String
    let period: Int
    let secret: Data
    let type: SecretType

    init(secret: Data, algorithm: Crypto.Algorithm = .sha1, digits: Int8 = 6) {
        self.algorithm = algorithm
        counter = 0
        self.digits = digits
        issuer = "issuer"
        label = "label"
        period = 30
        self.secret = secret
        type = .totp
    }
}

extension SharedSecret {
    init(from url: URL) {
        algorithm = .sha1
        counter = 0
        digits = 6
        issuer = url.getQuery(parameter: "issuer") ?? ""
        label = url.host ?? ""
        period = 30
        secret = url.getQuery(parameter: "secret")?.base32Decode() ?? Data()
        type = .totp
    }
}


extension SharedSecret {
    private func getHOTP(c: Int64) -> String {
        var c = c.bigEndian
        let localCounter = Data(bytes: &c, count: MemoryLayout<Int64>.size)

        let output = Crypto.HMAC(algorithm: algorithm, data: localCounter, key: secret)

        // RFC4226 Dynamic Truncation
        let offset = Int(output[algorithm.length - 1] & 0xF);
        // There's a lot of senseless casting here so the compiler doesn't panic on "complex" expressions.
        // What this is actually doing is output[offset...offset+3] & 0x7FFFFFFF
        let bytes: [UInt32] = [
            UInt32(UInt32(output[offset + 0] & 0x7F) << 24),
            UInt32(UInt32(output[offset + 1] & 0xFF) << 16),
            UInt32(UInt32(output[offset + 2] & 0xFF) <<  8),
            UInt32(UInt32(output[offset + 3] & 0xFF) <<  0),
        ]

        let byte = bytes.reduce(0, +)
        let intMod = byte % UInt32(Int(pow(Double(10), Double(digits))))

        return String(format: "%0\(digits)d", intMod)

    }

    func getOTP(at date: Date) -> String {
        let seconds = date.timeIntervalSince1970
        let periods = Int64(seconds / Double(period))
        return getHOTP(c: periods)
    }

    func getOTP() -> String {
        return getOTP(at: Date())
    }
}
