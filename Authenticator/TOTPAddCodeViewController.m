//
//  TOTPAddCodeViewController.m
//  Authenticator
//
//  Created by Eric Stern on 12/9/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import "TOTPAddCodeViewController.h"
#import "XQueryComponents.h"
#import "TOTPApp.h"
//#import "KeychainItemWrapper.h"

@interface TOTPAddCodeViewController ()

-(void) setupKeyboard;

@end

@implementation TOTPAddCodeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.saveButton.enabled = NO;
	// Do any additional setup after loading the view.
	[self setupKeyboard];
	[self.accountNameField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventAllEditingEvents];
	[self.secretField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Touch event handlers

-(IBAction)save:(id)sender {
	NSString *urlString = [NSString stringWithFormat:@"otpauth://totp/%@?secret=%@&period=%@&digits=%@&algorithm=%@"
						  , self.accountNameField.text.stringByEncodingURLFormat
						  , self.secretField.text
						  , self.stepField.text
						  , [self.digitsControl titleForSegmentAtIndex:self.digitsControl.selectedSegmentIndex]
						  , [self.algorithmControl titleForSegmentAtIndex:self.algorithmControl.selectedSegmentIndex]
						  ];
	NSURL *url = [NSURL URLWithString:urlString];
	if ([TOTPApp storeCodeWithUrl:url]) {
		[self closeController];
	}
	else {
		NSLog(@"Code with url %@ could not be saved", urlString);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save code. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}

-(IBAction)cancel:(id)sender {
	[self closeController];
}

#pragma mark Misc Event Handlers

-(void) textFieldDidChange {
	if ([self.accountNameField.text isEqualToString:@""] || [self.secretField.text isEqualToString:@""]) {
		self.saveButton.enabled = NO;
	}
	else {
		self.saveButton.enabled = YES;
	}
}

-(void) handlePrevNext:(id) sender {
	if ([sender isKindOfClass:[UISegmentedControl class]]) {
		NSUInteger idx = [sender selectedSegmentIndex];
		switch (idx) {
			case 0:
				[self focusPreviousField];
				break;
			case 1:
				[self focusNextField];
				break;
			default:
				NSLog(@"Unhandled index %d in %s", idx, __FUNCTION__);
				break;
		}
	}
}

#pragma mark Internal UI tools

-(void) focusPreviousField {
	if ([self.stepField isFirstResponder]) {
		[self.secretField becomeFirstResponder];
	}
	else if ([self.secretField isFirstResponder]) {
		[self.accountNameField becomeFirstResponder];
	}
	else if ([self.accountNameField isFirstResponder]) {
		[self.stepField becomeFirstResponder];
	}
}

-(void) focusNextField {
	if ([self.accountNameField isFirstResponder]) {
		[self.secretField becomeFirstResponder];
	}
	else if ([self.secretField isFirstResponder]) {
		[self.stepField becomeFirstResponder];
	}
	else if ([self.stepField isFirstResponder]) {
		[self.accountNameField becomeFirstResponder];
	}
}

-(void) setupKeyboard {
	UISegmentedControl *prevNext = [[UISegmentedControl alloc] initWithItems:@[@"Previous", @"Next"]];
	prevNext.momentary = YES;
	[prevNext addTarget:self action:@selector(handlePrevNext:) forControlEvents:UIControlEventValueChanged];
	[prevNext sizeToFit];
	
	UIToolbar *toolbar = [[UIToolbar alloc] init];
	toolbar.barStyle = UIBarStyleDefault;
	toolbar.tintColor = self.view.tintColor;
	toolbar.items =
	@[ [[UIBarButtonItem alloc] initWithCustomView:prevNext]
	 , [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]
	 , [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(removeKeyboard)]
	];
	[toolbar sizeToFit];
	self.accountNameField.inputAccessoryView = toolbar;
	self.secretField.inputAccessoryView = toolbar;
	self.stepField.inputAccessoryView = toolbar;
}

-(void) removeKeyboard {
	if ([self.accountNameField isFirstResponder]) {
		[self.accountNameField resignFirstResponder];
	}
	else if ([self.secretField isFirstResponder]) {
		[self.secretField resignFirstResponder];
	}
	else if ([self.stepField isFirstResponder]) {
		[self.stepField resignFirstResponder];
	}
}

-(void) closeController {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	// only operate on the secret field
	if (textField != self.secretField) {
		return YES;
	}
	NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	// First normalize ambiguous characters into Base32 alphabet
	resultString = [[resultString uppercaseString] stringByReplacingOccurrencesOfString:@"1" withString:@"I"];
	resultString = [[resultString uppercaseString] stringByReplacingOccurrencesOfString:@"0" withString:@"O"];

	// Prep scrubbing regex
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^A-Z2-7]" options:0 error:nil];
	
	// Apply scrubber
	NSString *clean  = [regex stringByReplacingMatchesInString:resultString options:0 range:NSMakeRange(0, resultString.length) withTemplate:@""];
	
	// Cool - all done. Replace the text field and ignore the user's direct input
	textField.text = clean;
	[self textFieldDidChange]; // simulate our change event for save button handler
	return NO;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
	switch (textField.returnKeyType) {
		case UIReturnKeyNext:
			[self focusNextField];
			return NO;
		case UIReturnKeyDone:
		case UIReturnKeyDefault:
			[self removeKeyboard];
		default:
			NSLog(@"Unhandled field type in %s: %d", __FUNCTION__, textField.returnKeyType);
			break;
	}
	return YES;
}

@end
