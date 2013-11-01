//
//  KKRootViewController.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/11/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKViewController.h"
#import <PSTCollectionView.h>

@interface KKRootViewController : UIViewController <UINavigationControllerDelegate> {
    KKViewController *collectionViewController;
    PSUICollectionView *collectionView;
    NSTimer *reloadTimer;
}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UISegmentedControl *filterControl;

- (IBAction)refreshTapped:(id)sender;
- (IBAction)filterSelected:(id)sender;

@end
