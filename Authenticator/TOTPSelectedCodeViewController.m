//
//  TOTPSelectedCodeViewController.m
//  Authenticator
//
//  Created by Eric Stern on 12/13/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import "TOTPSelectedCodeViewController.h"
#import "TOTPCode.h"
#import "KeychainItemWrapper.h"

@interface TOTPSelectedCodeViewController ()

@property (nonatomic) TOTPCode *code;

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
	NSString *urlString = [KeychainItemWrapper passwordWithKey:self.codeId];

	if ([urlString isEqualToString:@""]) {
		NSLog(@"Code %@ not found in keychain", self.codeId);
		self.codeLabel.text = @"";
		self.countdownLabel.text = @"0";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"That code was not found in the Keychain" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		return;
	}

	self.code = [TOTPCode codeWithURL:[NSURL URLWithString:urlString] returningError:nil];
	
    [self configureView];
    self.title = self.code.description;
	self.view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:250.0/255.0 blue:246.0/255.0 alpha:1];
	self.codeLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:32.0/255.0 blue:59.0/255.0 alpha:1];
	self.countdownLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:125.0/255.0 blue:123.0/255.0 alpha:1];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(configureView) userInfo:nil repeats:YES];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
