//
//  KKDetailViewController.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/2/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKUser.h"

@interface KKDetailViewController : UIViewController {
    UIAlertView *alertView;
    NSTimer *timer;
    BOOL backSelectorScheduled;
}

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCupsLabel;

@property (strong, nonatomic) KKUser *currentUser;

- (void)goBack;
- (IBAction)back:(id)sender;
- (IBAction)cupup:(id)sender;
- (IBAction)cancelLastCup:(id)sender;

@end
