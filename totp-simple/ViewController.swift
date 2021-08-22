//
//  ViewController.swift
//  totp-simple
//
//  Created by Eric Stern on 10/2/17.
//  Copyright © 2017 Eric Stern. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: "otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example")!
        let url2 = URL(string: "otpauth://totp/Bitrex?secret=UH56T54WKYF6LIBS")!
        let secret = SharedSecret(from: url2)
//        print(secret)

//        Timer.sch
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
//            print(secret.getOTP())
        }

//        print(url?.getQuery(parameter: "secret")?.base32Decode())
//        print(url?.getQuery(parameter: "nope"))
//        print(url?.getQuery(parameter: "issuer"))
//        let components = URLComponents(url: url!, resolvingAgainstBaseURL: true)!
//        let queries = components.queryItems!
//        let first = queries.first!
//        first.
        /*
         scheme=otpauth
         host=totp
         path=/Example:alice@google.com
         pathComponents=["/", "Example:alice@google.com"]
         
         components = URLComponents(string: url!.absoluteString)
         components.queryItems! =
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


