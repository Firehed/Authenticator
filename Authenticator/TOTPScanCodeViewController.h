//
//  TOTPScanCodeViewController.h
//  Authenticator
//
//  Created by Eric Stern on 6/28/13.
//  Copyright (c) 2013 Eric Stern. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TOTPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
- (IBAction)cancelButtonPressed:(id)sender;

@end
