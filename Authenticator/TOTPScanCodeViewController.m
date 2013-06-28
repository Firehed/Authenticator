//
//  TOTPScanCodeViewController.m
//  Authenticator
//
//  Created by Eric Stern on 6/28/13.
//  Copyright (c) 2013 Eric Stern. All rights reserved.
//

#import "TOTPScanCodeViewController.h"
#import "TOTPApp.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TOTPScanCodeViewController ()

@property BOOL processing;

@end

@implementation TOTPScanCodeViewController

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
	self.processing = NO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidAppear:(BOOL)animated {
	
    [super viewDidAppear:animated];
    NSError* error;
    
    AVCaptureSession* session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetMedium];
    
    AVCaptureDevice* audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	
    AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:CGRectMake(0, 0, rootLayer.bounds.size.height, rootLayer.bounds.size.height)];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    [session startRunning];
    
    AVCaptureMetadataOutput* output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    // desired barcode types
    output.metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ];
}

- (void)closeModal {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
	// AV Framework spits output too fast, deal with dupes
    if (self.processing) {
		return;
	}
	if (!metadataObjects.count) {
		return;
	}
	self.processing = YES;

    AVMetadataMachineReadableCodeObject* barcode = [metadataObjects objectAtIndex:0];
	if ([TOTPApp storeCodeWithUrl:[NSURL URLWithString:barcode.stringValue]]) {
		AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
		[self closeModal];
	}
	else {
		// Code was bogus. App handles logging
		self.processing = NO;
	}
	// end AV session?
}


- (IBAction)cancelButtonPressed:(id)sender {
	[self closeModal];
}
@end
