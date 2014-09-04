//
//  String+SHA256.swift
//  sedit
//
//  Created by Nerry Kitazato on 2014/08/31.
//  Copyright (c) 2014年 Nerry Kitazato. All rights reserved.
//

import Foundation

extension String {

    func sha256() -> NSData! {
        var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        CC_SHA256(data!.bytes, CC_LONG(data!.length), &hash)
        let result = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH))
        return result
    }

}
