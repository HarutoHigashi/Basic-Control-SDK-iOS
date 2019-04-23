//
//  DRViewController.m
//  DoubleBasicHelloWorld
//
//  Created by David Cann on 8/3/13.
//  Copyright (c) 2013 Double Robotics, Inc. All rights reserved.
//

#import "DRViewController.h"
#import <DoubleControlSDK/DoubleControlSDK.h>
#import <CameraKitSDK/CameraKitSDK.h>

//カメラのデリゲート追加
@interface DRViewController () <DRDoubleDelegate,DRCameraKitImageDelegate,DRCameraKitConnectionDelegate>
@end

@implementation DRViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[DRDouble sharedDouble].delegate = self;
    //カメラ
    [DRCameraKit sharedCameraKit].imageDelegate = self;
    [DRCameraKit sharedCameraKit].connectionDelegate = self;
    //[[DRCameraKit sharedCameraKit] setCameraSettingsWithArray:(cameraSetting *)kCameraSettings1280x960_30FPS];
    [[DRCameraKit sharedCameraKit] setCameraSettingsWithArray:(cameraSetting *)kCameraSettingsFullRes_15FPS];
	NSLog(@"SDK Version: %@", kDoubleBasicSDKVersion);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

#pragma mark - Actions

- (IBAction)poleUp:(id)sender {
	[[DRDouble sharedDouble] poleUp];
}

- (IBAction)poleStop:(id)sender {
	[[DRDouble sharedDouble] poleStop];
}

- (IBAction)poleDown:(id)sender {
	[[DRDouble sharedDouble] poleDown];
}

- (IBAction)kickstandsRetract:(id)sender {
	[[DRDouble sharedDouble] retractKickstands];
}

- (IBAction)kickstandsDeploy:(id)sender {
	[[DRDouble sharedDouble] deployKickstands];
}

- (IBAction)startTravelData:(id)sender {
	[[DRDouble sharedDouble] startTravelData];
}

- (IBAction)stopTravelData:(id)sender {
	[[DRDouble sharedDouble] stopTravelData];
}

- (IBAction)headPowerOn:(id)sender {
	[[DRDouble sharedDouble] headPowerOn];
}

- (IBAction)headPowerOff:(id)sender {
	[[DRDouble sharedDouble] headPowerOff];
}

#pragma mark - DRDoubleDelegate

- (void)doubleDidConnect:(DRDouble *)theDouble {
	statusLabel.text = @"Connected";
}

- (void)doubleDidDisconnect:(DRDouble *)theDouble {
	statusLabel.text = @"Not Connected";
}

- (void)doubleStatusDidUpdate:(DRDouble *)theDouble {
	poleHeightPercentLabel.text = [NSString stringWithFormat:@"%f", [DRDouble sharedDouble].poleHeightPercent];
	kickstandStateLabel.text = [NSString stringWithFormat:@"%d", [DRDouble sharedDouble].kickstandState];
	batteryPercentLabel.text = [NSString stringWithFormat:@"%f", [DRDouble sharedDouble].batteryPercent];
	batteryIsFullyChargedLabel.text = [NSString stringWithFormat:@"%d", [DRDouble sharedDouble].batteryIsFullyCharged];
	firmwareVersionLabel.text = [DRDouble sharedDouble].firmwareVersion;
	serialLabel.text = [DRDouble sharedDouble].serial;
}

- (void)doubleDriveShouldUpdate:(DRDouble *)theDouble {
	float drive = (driveForwardButton.highlighted) ? kDRDriveDirectionForward : ((driveBackwardButton.highlighted) ? kDRDriveDirectionBackward : kDRDriveDirectionStop);
	float turn = (driveRightButton.highlighted) ? 1.0 : ((driveLeftButton.highlighted) ? -1.0 : 0.0);
	[theDouble drive:drive turn:turn];
}

- (void)doubleTravelDataDidUpdate:(DRDouble *)theDouble {
	leftEncoderLabel.text = [NSString stringWithFormat:@"%.02f", [leftEncoderLabel.text floatValue] + [DRDouble sharedDouble].leftEncoderDeltaInches];
	rightEncoderLabel.text = [NSString stringWithFormat:@"%.02f", [rightEncoderLabel.text floatValue] + [DRDouble sharedDouble].rightEncoderDeltaInches];
	NSLog(@"Left Encoder: %f, Right Encoder: %f", theDouble.leftEncoderDeltaInches, theDouble.rightEncoderDeltaInches);
}

#pragma mark - DRCameraKitImageDelegate

- (void)cameraKit:(DRCameraKit *)theKit didReceiveImage:(UIImage *)theImage sizeInBytes:(NSInteger)length {
    mainImageView.image = theImage;
}

#pragma mark - DRCameraKitConnectionDelegate

- (void)cameraKitConnectionStatusDidChange:(DRCameraKit *)theKit {
    connectionStatusLabel.text = (theKit.isConnected) ? @"Connected" : @"Not Connected";
}


@end
