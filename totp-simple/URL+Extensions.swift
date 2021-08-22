//
//  URL+Extensions.swift
//  totp-simple
//
//  Created by Eric Stern on 10/5/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import Foundation

extension URL {
    func getQuery(parameter: String) -> String? {
        return URLComponents(url: self, resolvingAgainstBaseURL: true)?
            .queryItems?
            .first { $0.name == parameter }?
            .value
    }
}
