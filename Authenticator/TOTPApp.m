//
//  TOTPApp.m
//  Authenticator
//
//  Created by Eric Stern on 6/28/13.
//  Copyright (c) 2013 Eric Stern. All rights reserved.
//

#import "TOTPApp.h"
#import "TOTPCode.h"
#import "KeychainItemWrapper.h"

NSString* const codesKey = @"codes";

@implementation TOTPApp

+(NSArray *)codes {
	NSUserDefaults *def = [[NSUserDefaults alloc] init];
	NSArray *codes = [def objectForKey:codesKey];
	if (!codes) {
		codes = @[];
		[def setObject:codes forKey:codesKey];
		[def synchronize];
	}
	return codes;
}

+(TOTPCode *)codeWithName:(NSString *)name {
	NSString *urlString = [KeychainItemWrapper passwordWithKey:name];
	TOTPCode *ret;
	if ([urlString isEqualToString:@""]) {
		NSLog(@"Code %@ not found in keychain", name);
		ret = nil;
	}

	ret = [TOTPCode codeWithURL:[NSURL URLWithString:urlString] returningError:nil];
	
	return ret;
}

@end
