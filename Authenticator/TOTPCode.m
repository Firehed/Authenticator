//
//  TOTPCode.m
//  Authenticator
//
//  Created by Eric Stern on 12/8/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import "TOTPCode.h"
#import "MF_Base32Additions.h"
#import "XQueryComponents.h"

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
	if (![_secret length]) {
		return @"No secret";
	}
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

-(void) setAlgorithm:(NSString *)algorithm {
	// validate me!
	_algorithm = [algorithm uppercaseString];
}

-(NSNumber *) timeLeftInPeriod {
	uint64_t now = [[NSDate date] timeIntervalSince1970];
    uint64_t periods = (uint64_t) floor(now / [_step intValue]);
	int diff = [_step intValue] - (now - (periods * [_step intValue]));
	return [NSNumber numberWithInt:diff];

}

// Valid URL format: otpauth://type/label?params
// type: only "totp" is supported
// label: any string
// params include:
// secret: required
// algorithm: optional (default SHA1), allowed SHA1, SHA256, SHA512
// digits: optional (default 6), allowed numeric values >= 6
// period: optional (default 30), allowed numeric values
+(TOTPCode *) codeWithURL:(NSURL *)url returningError:(NSError **)err {
	
	if (![[url.scheme lowercaseString] isEqualToString:@"otpauth"]) {
		*err = [NSError errorWithDomain:@"TOTP" code:0 userInfo:@{NSLocalizedDescriptionKey:@"invalid scheme"}];
		return nil;
	}
	if (![[url.host lowercaseString] isEqualToString:@"totp"]) {
		*err = [NSError errorWithDomain:@"TOTP" code:0 userInfo:@{NSLocalizedDescriptionKey:@"invalid host - only totp is supported"}];
		return nil;
	}

	NSString *description = [[url.pathComponents objectAtIndex:1] stringByDecodingURLFormat];
	
	NSDictionary *query = [url queryComponents];
	id algorithm = [query objectForKey:@"algorithm"][0];
	id digits = [query objectForKey:@"digits"][0];
	id period = [query objectForKey:@"period"][0];
	id secret = [query objectForKey:@"secret"][0];

	
	TOTPCode *code = [[TOTPCode alloc] init];

	if (secret) {
		code.secret = [NSData dataWithBase32String:secret];
	}
	else {
		*err = [NSError errorWithDomain:@"TOTP" code:0 userInfo:@{NSLocalizedDescriptionKey:@"required field 'secret' is not present"}];
		return nil;
	}
	if (digits) {
		code.digits = [NSNumber numberWithInt:[digits intValue]];
	}
	if (period) {
		code.step = [NSNumber numberWithInt:[period intValue]];
	}
	if (algorithm) {
		code.algorithm = algorithm;
	}
	
	code.description = description;
	return code;
}

@end
