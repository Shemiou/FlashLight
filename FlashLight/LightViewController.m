//
//  LightViewController.m
//  FlashLight
//
//  Created by Charles Wang on 16/4/18.
//  Copyright © 2016年 MeeLive. All rights reserved.
//

#import "LightViewController.h"

static NSInteger sos = 0;

@interface LightViewController () {
  NSTimer *timerFlash;
  bool enableFlash;
}
@property(weak, nonatomic) IBOutlet UIButton *lightBtn;
@property(weak, nonatomic) IBOutlet UISwitch *sosSwitch;

@end

@implementation LightViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  _isLightOn = YES;
  _sosSwitch.on = enableFlash;

  if (![self isDeviceHasTorch]) {
    [self showAlert];
    return;
  }

  [self turnOff:YES];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  self.lightBtn = nil;
  self.sosSwitch = nil;
}

- (BOOL)isDeviceHasTorch {
  AVCaptureDevice *device =
      [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if (![device hasTorch]) {
    return NO;
  }
  return YES;
}

- (void)showAlert {
  UIAlertView *alert = [[UIAlertView alloc]
          initWithTitle:@"温馨提示"
                message:
                    @"抱"
                    @"歉"
                    @"，"
                    @"该设备没有闪光灯而无法使用手电筒功能！"
               delegate:nil
      cancelButtonTitle:@"确定"
      otherButtonTitles:nil];

  [alert show];
}

- (void)turnOn:(bool)update {
  [self torchOn:YES];
  if (update) {
    //    [self btnImageName:@"powerbuttonon.png"];
  }
}

- (void)torchOn:(BOOL)on {
  AVCaptureDevice *device =
      [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if ([device hasTorch]) {
    [device lockForConfiguration:nil];
    if (on) {
      [device setTorchMode:AVCaptureTorchModeOn];
    } else {
      [device setTorchMode:AVCaptureTorchModeOff];
    }

    [device unlockForConfiguration];
  }
}

- (void)btnImageName:(NSString *)imgName {
  [_lightBtn setImage:[UIImage imageNamed:imgName]
             forState:UIControlStateNormal];
}

- (void)turnOff:(bool)update {
  [self torchOn:NO];
  if (update) {
    //    [self btnImageName:@"powerbuttonoff.png"];
  }
}

- (void)switchOff:(id)sender {
  if (sender) {
    if (_isLightOn) {
      [self turnOn:YES];
    } else {
      [self turnOff:YES];
    }
    isFlashOn = NO;
  } else {
    _isLightOn = NO;
    [self turnOff:YES];
    //    [self btnImageName:@"powerbuttonoff.png"];
  }
}

- (void)switchOn:(id)sender {
  if (sender) {
    isFlashOn = YES;
  } else {
    //    [self btnImageName:@"powerbuttonon.png"];
  }
  _isLightOn = YES;
  [self turnOn:YES];
}

- (void)onBtnFlash {
  enableFlash = 1 - enableFlash;
  if (!enableFlash) {
    _isLightOn = NO;
    [self turnOff:YES];
    //    [self btnImageName:@"powerbuttonoff.png"];
    _sosSwitch.on = enableFlash;
  } else {
    //    [self btnImageName:@"powerbuttonon.png"];
    _sosSwitch.on = enableFlash;
    _isLightOn = YES;
    [self turnOn:YES];
  }

  [self ledFlash];
}

- (void)ledFlash {
  double time = 1.0 / 2;

  if (!enableFlash) {
    return;
  }

  if (timerFlash) {
    [timerFlash invalidate];
    timerFlash = nil;
  }
  timerFlash = [NSTimer scheduledTimerWithTimeInterval:time
                                                target:self
                                              selector:@selector(onTimerFlash)
                                              userInfo:nil
                                               repeats:YES];
}

- (void)onTimerFlash {
  static int count = 0;

  if (!enableFlash) {
    return;
  }

  if (count % 2) {
    [self turnOn:NO];
  } else {
    [self turnOff:NO];
  }
  count++;
}

- (IBAction)lightAction:(id)sender {
  if (isFlashOn) {
    [self onBtnFlash];
  } else {
    _isLightOn = 1 - _isLightOn;
    if (_isLightOn) {
      [self turnOn:YES];
    } else {
      [self turnOff:YES];
    }
  }
}

- (IBAction)sosSwitch:(id)sender {
  UISwitch *uiSwitch = (UISwitch *)sender;

  enableFlash = uiSwitch.on;

  if (!enableFlash) {
    [self switchOff:sender];
  } else {
    if (sender) {
      isFlashOn = YES;
    } else {
      //      [self btnImageName:@"powerbuttonon.png"];
    }
    _isLightOn = YES;
    [self sosLight];
  }
}

- (void)sosLight {
  // s
  [self ledFlashS];
}

// s
- (void)ledFlashS {
  double time = 1.0;

  if (!enableFlash) {
    return;
  }

  if (timerFlash) {
    [timerFlash invalidate];
    timerFlash = nil;
  }

  timerFlash = [NSTimer scheduledTimerWithTimeInterval:time
                                                target:self
                                              selector:@selector(onTimerS)
                                              userInfo:nil
                                               repeats:YES];
  [timerFlash fire];
}

- (void)onTimerS {
  static int count = 0;

  if (!enableFlash) {
    return;
  }

  if (count < 6) {
    if (count % 2) {
      [self turnOn:YES];
    } else {
      [self turnOff:YES];
    }

    count++;
  } else {
    if (sos % 2) {
      count = 0;
      [self onTimerS];

      sos++;
    } else {
      [self ledFlashO];
    }
    count = 0;
  }
}

// o
- (void)ledFlashO {
  double time = 2.0;

  if (!enableFlash) {
    return;
  }

  if (timerFlash) {
    [timerFlash invalidate];
    timerFlash = nil;
  }
  timerFlash = [NSTimer scheduledTimerWithTimeInterval:time
                                                target:self
                                              selector:@selector(onTimerO)
                                              userInfo:nil
                                               repeats:YES];
  [timerFlash fire];
}

- (void)onTimerO {
  static int count = 0;

  if (!enableFlash) {
    return;
  }

  if (count < 6) {
    if (count % 2) {
      [self turnOn:YES];
    } else {
      [self turnOff:YES];
    }

    count++;
  } else {
    [self ledFlashS];
    count = 0;
    sos++;
  }
}

@end
