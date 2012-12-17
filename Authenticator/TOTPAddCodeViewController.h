//
//  TOTPAddCodeViewController.h
//  Authenticator
//
//  Created by Eric Stern on 12/9/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TOTPAddCodeViewController : UIViewController <UITextFieldDelegate>

-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *accountNameField;
@property (weak, nonatomic) IBOutlet UITextField *secretField;
@property (weak, nonatomic) IBOutlet UITextField *stepField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *digitsControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *algorithmControl;

@end
