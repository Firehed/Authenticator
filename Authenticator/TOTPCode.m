//
//  TOTPCode.m
//  Authenticator
//
//  Created by Eric Stern on 12/8/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import "TOTPCode.h"
#include <CommonCrypto/CommonHMAC.h>

@interface TOTPCode ()
@property (nonatomic, copy) NSNumber *digits;
@property (nonatomic, copy) NSString *algorithm;
@property (nonatomic, copy) NSData *secret;
@end

@implementation TOTPCode


-(TOTPCode *) init {
    if (![super init]) {
        return nil;
    }
    _digits = @6;
    _step = @30;
    _algorithm = @"SHA1";
    _secret = [[NSData alloc] init];
    return self;
}

-(NSString *) currentCode {
    uint64_t now = [[NSDate date] timeIntervalSince1970];
	return [self codeAtTime:now];
}


-(NSString *) codeAtTime:(uint64_t) time {
	uint64_t periods = (uint64_t) floor(time / [_step intValue]);

    // Crypto work is mostly copied from actual Google Authenticator app, see:
    // http://code.google.com/p/google-authenticator/source/browse/mobile/ios/Classes/OTPGenerator.m

    CCHmacAlgorithm alg;
    NSUInteger hashLength = 0;
    if ([_algorithm isEqualToString:@"SHA1"]) {
        alg = kCCHmacAlgSHA1;
        hashLength = CC_SHA1_DIGEST_LENGTH;
    }
    else if ([_algorithm isEqualToString:@"SHA256"]) {
        alg = kCCHmacAlgSHA256;
        hashLength = CC_SHA256_DIGEST_LENGTH;
    }
    else if ([_algorithm isEqualToString:@"SHA512"]) {
        alg = kCCHmacAlgSHA512;
        hashLength = CC_SHA512_DIGEST_LENGTH;
    }
    else {
        NSLog(@"Trying to generate code with invalid algorithm <%@>", _algorithm);
        return nil;
    }
    
    
    NSMutableData *hash = [NSMutableData dataWithLength:hashLength];
    uint64_t counter = NSSwapHostLongLongToBig(periods);
    NSData *counterData = [NSData dataWithBytes:&counter length:sizeof(counter)];

    CCHmacContext ctx;
    CCHmacInit(&ctx, alg, [_secret bytes], [_secret length]);
    CCHmacUpdate(&ctx, [counterData bytes], [counterData length]);
    CCHmacFinal(&ctx, [hash mutableBytes]);
    
    const char *ptr = [hash bytes];
    unsigned char offset = ptr[hashLength -1] & 0x0F;
    unsigned long truncatedHash = NSSwapBigLongToHost(*((unsigned long *) &ptr[offset])) & 0x7FFFFFFF;
    
    unsigned long mod = pow(10, [_digits doubleValue]);
    unsigned long code = truncatedHash % mod;
    
    return [NSString stringWithFormat:@"%0*ld", [_digits integerValue], code];
}

-(NSNumber *) timeLeftInPeriod {
	uint64_t now = [[NSDate date] timeIntervalSince1970];
    uint64_t periods = (uint64_t) floor(now / [_step intValue]);
	int diff = [_step intValue] - (now - (periods * [_step intValue]));
	return [NSNumber numberWithInt:diff];

}


@end
