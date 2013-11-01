//
//  KKNewUserViewController.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/10/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKRootViewController.h"

@interface KKNewUserViewController : UIViewController

@property (assign, nonatomic) KKRootViewController *callingViewController;
@property (strong, nonatomic) IBOutlet UITextField *fullname;
@property (strong, nonatomic) IBOutlet UITextField *email;

- (IBAction)cancel:(id)sender;

- (IBAction)done:(id)sender;

@end
