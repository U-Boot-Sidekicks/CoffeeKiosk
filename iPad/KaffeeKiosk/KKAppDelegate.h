//
//  KKAppDelegate.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/19/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface KKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RKObjectManager *objectManager;

+ (KKAppDelegate *)appDelegate;

@end
