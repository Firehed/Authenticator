//
//  AuthenticatorTests.m
//  AuthenticatorTests
//
//  Created by Eric Stern on 12/9/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import "AuthenticatorTests.h"
#import "TOTPCode.h"

@implementation AuthenticatorTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

+(NSData *) getSecretForAlgorithm:(NSString *) alg {
	if ([alg isEqualToString:@"SHA1"]) {
		return [@"12345678901234567890" dataUsingEncoding:NSUTF8StringEncoding];
	}
	else if ([alg isEqualToString:@"SHA256"]) {
		return [@"12345678901234567890123456789012" dataUsingEncoding:NSUTF8StringEncoding];
	}
	else if ([alg isEqualToString:@"SHA512"]) {
		return [@"1234567890123456789012345678901234567890123456789012345678901234" dataUsingEncoding:NSUTF8StringEncoding];
	}
	else {
		return nil;
	}
}

+(TOTPCode *) codeWithAlgorithm:(NSString *)alg {
	TOTPCode *code = [[TOTPCode alloc] init];
	code.digits = @8;
	code.algorithm = alg;
	code.secret = [self getSecretForAlgorithm:alg];
	return code;
}

// http://tools.ietf.org/html/rfc6238#appendix-B
-(void) testRFC6238Vectrors {
	TOTPCode *sha1 = [AuthenticatorTests codeWithAlgorithm:@"SHA1"];
	TOTPCode *sha256 = [AuthenticatorTests codeWithAlgorithm:@"SHA256"];
	TOTPCode *sha512 = [AuthenticatorTests codeWithAlgorithm:@"SHA512"];

	STAssertEqualObjects([sha1 codeAtTime:59]  , @"94287082", @"59/SHA1");
	STAssertEqualObjects([sha256 codeAtTime:59], @"46119246", @"59/SHA256");
	STAssertEqualObjects([sha512 codeAtTime:59], @"90693936", @"59/SHA512");

	STAssertEqualObjects([sha1 codeAtTime:1111111109]  , @"07081804", @"1111111109/SHA1");
	STAssertEqualObjects([sha256 codeAtTime:1111111109], @"68084774", @"1111111109/SHA256");
	STAssertEqualObjects([sha512 codeAtTime:1111111109], @"25091201", @"1111111109/SHA512");

	STAssertEqualObjects([sha1 codeAtTime:1111111111]  , @"14050471", @"1111111111/SHA1");
	STAssertEqualObjects([sha256 codeAtTime:1111111111], @"67062674", @"1111111111/SHA256");
	STAssertEqualObjects([sha512 codeAtTime:1111111111], @"99943326", @"1111111111/SHA512");

	STAssertEqualObjects([sha1 codeAtTime:1234567890]  , @"89005924", @"1234567890/SHA1");
	STAssertEqualObjects([sha256 codeAtTime:1234567890], @"91819424", @"1234567890/SHA256");
	STAssertEqualObjects([sha512 codeAtTime:1234567890], @"93441116", @"1234567890/SHA512");

	STAssertEqualObjects([sha1 codeAtTime:2000000000]  , @"69279037", @"2000000000/SHA1");
	STAssertEqualObjects([sha256 codeAtTime:2000000000], @"90698825", @"2000000000/SHA256");
	STAssertEqualObjects([sha512 codeAtTime:2000000000], @"38618901", @"2000000000/SHA512");

	STAssertEqualObjects([sha1 codeAtTime:20000000000]  , @"65353130", @"20000000000/SHA1");
	STAssertEqualObjects([sha256 codeAtTime:20000000000], @"77737706", @"20000000000/SHA256");
	STAssertEqualObjects([sha512 codeAtTime:20000000000], @"47863826", @"20000000000/SHA512");


}

@end
