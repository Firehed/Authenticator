//
//  TOTPCode.h
//  Authenticator
//
//  Created by Eric Stern on 12/8/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TOTPCode : NSObject

@property (nonatomic, copy) NSNumber *step;
@property (nonatomic, copy) NSString *description;

-(NSString *) currentCode;
-(void) setSecretWithBase32String:(NSString *) base32Key;
-(void) setSecret:(NSData *) secret;
-(void) setDigits:(NSNumber *) digits;
-(void) setAlgorithm:(NSString *) algorithm;

@end
