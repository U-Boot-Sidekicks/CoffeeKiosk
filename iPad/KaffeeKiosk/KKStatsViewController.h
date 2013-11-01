//
//  KKStatsViewController.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 6/14/13.
//  Copyright (c) 2013 Fraunhofer FIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKStatsViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)closeStats:(id)sender;

@end
