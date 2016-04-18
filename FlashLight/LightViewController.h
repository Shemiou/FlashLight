//
//  LightViewController.h
//  FlashLight
//
//  Created by Charles Wang on 16/4/18.
//  Copyright © 2016年 MeeLive. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface LightViewController : UIViewController {
  bool isFlashOn;
}

@property bool isLightOn;
- (void)turnOff:(bool)update;
- (void)turnOn:(bool)update;

@end
