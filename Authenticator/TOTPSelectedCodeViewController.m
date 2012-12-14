//
//  TOTPSelectedCodeViewController.m
//  Authenticator
//
//  Created by Eric Stern on 12/13/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import "TOTPSelectedCodeViewController.h"
#import "TOTPCode.h"

@interface TOTPSelectedCodeViewController ()

@end

@implementation TOTPSelectedCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) configureView {
    self.codeLabel.text = self.code.currentCode;
    self.countdownLabel.text = self.code.timeLeftInPeriod.stringValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    self.title = self.code.description;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(configureView) userInfo:nil repeats:YES];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
