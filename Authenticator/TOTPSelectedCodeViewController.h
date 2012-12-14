//
//  TOTPSelectedCodeViewController.h
//  Authenticator
//
//  Created by Eric Stern on 12/13/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TOTPCode;

@interface TOTPSelectedCodeViewController : UIViewController

@property (weak, nonatomic) TOTPCode *code;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

@end
