//
//  TOTPAddCodeViewController.m
//  Authenticator
//
//  Created by Eric Stern on 12/9/12.
//  Copyright (c) 2012 Eric Stern. All rights reserved.
//

#import "TOTPAddCodeViewController.h"

@interface TOTPAddCodeViewController ()

@end

@implementation TOTPAddCodeViewController

-(IBAction)save:(id)sender {
    NSLog(@"save action");
#warning this is not implemented yet
}

-(IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
