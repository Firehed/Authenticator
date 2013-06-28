//
//  TOTPApp.h
//  Authenticator
//
//  Created by Eric Stern on 6/28/13.
//  Copyright (c) 2013 Eric Stern. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TOTPCode;

@interface TOTPApp : NSObject

+(NSArray *) codes;

+(TOTPCode *) codeWithName:(NSString *)name;


@end
