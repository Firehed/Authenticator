//
//  TOTPScanCodeViewController.m
//  Authenticator
//
//  Created by Eric Stern on 6/28/13.
//  Copyright (c) 2013 Eric Stern. All rights reserved.
//

#import "TOTPScanCodeViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TOTPScanCodeViewController ()

@property double lastScan;
//@property UILabel* labelBarcode;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidAppear:(BOOL)animated {
	
    [super viewDidAppear:animated];
/*
    _labelBarcode = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    _labelBarcode.backgroundColor = [UIColor darkGrayColor];
    _labelBarcode.textColor = [UIColor whiteColor];
    [self.view addSubview:_labelBarcode];
  */  
    _lastScan = [[NSDate date] timeIntervalSince1970];
    
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
//    [previewLayer setFrame:CGRectMake(-70, 60, rootLayer.bounds.size.height, rootLayer.bounds.size.height)];
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
    
	if (metadataObjects.count == 0) return;
    AVMetadataMachineReadableCodeObject* barcode = [metadataObjects objectAtIndex:0];
	NSLog(@"%@", barcode.stringValue);
//    _labelBarcode.text = [NSString stringWithFormat:@" SCAN >> %@", barcode.stringValue];
    
    double currenTime = [[NSDate date] timeIntervalSince1970];
    if (currenTime - _lastScan >= 1) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        _lastScan = currenTime;
    }
	[self closeModal];
	// end session
}


- (IBAction)cancelButtonPressed:(id)sender {
	[self closeModal];
}
@end
