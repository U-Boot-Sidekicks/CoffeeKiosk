//
//  KKDetailViewController.m
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/2/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import "KKDetailViewController.h"
#import "KKAppDelegate.h"
#import "KKCup.h"

@interface KKDetailViewController ()
- (void)updateInterface;
- (void)timerCallback;
@end

@implementation KKDetailViewController

@synthesize currentUser;

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
    
    backSelectorScheduled = NO;
    
    [self updateInterface];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateInterface {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [defaults stringForKey:@"baseurl_preference"];

    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/img/%@", baseURL, currentUser.thumbnailFilename]];
    [self.image setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"User.png"]];
    
    [self.nameLabel setText:currentUser.name];
    [self.balanceLabel setText:[currentUser formattedBalance]];
    [self.totalCupsLabel setText:[NSString stringWithFormat:@"%i", [currentUser.totalCups integerValue]]];
}

- (void)timerCallback {
    if (alertView != nil && !alertView.isHidden) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)goBack
{
    if (backSelectorScheduled) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cupup:(id)sender
{
    backSelectorScheduled = NO;
    
    if (timer != nil && [timer isValid]) {
        [timer invalidate];
    }
    
    KKCup *cup = [KKCup new];
    cup.userId = currentUser.userId;
    
    KKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.objectManager postObject:cup path:@"/api/cups" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        KKUser *user = [KKUser new];
        user.userId = currentUser.userId;
        [appDelegate.objectManager getObject:user path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            currentUser = [mappingResult firstObject];
            [self updateInterface];
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to execute GET /api/cups - %@", [error localizedDescription]);
        }];
        
        alertView = [[UIAlertView alloc] initWithTitle:@"INFO"
                                                            message:@"Enjoy your coffee!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK",nil];
        alertView.tag = 0;
        [alertView show];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerCallback) userInfo:nil repeats:NO];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to post the cup: %@", [error localizedDescription]);
    }];
}

- (IBAction)cancelLastCup:(id)sender
{
    backSelectorScheduled = NO;
    
    if (timer != nil && [timer isValid]) {
        [timer invalidate];
    }
    
    KKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.objectManager deleteObject:nil path:@"/api/cups" parameters:@{ @"last":[NSNumber numberWithBool:YES], @"user_id":currentUser.userId } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        KKUser *user = [KKUser new];
        user.userId = currentUser.userId;
        [appDelegate.objectManager getObject:user path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            currentUser = [mappingResult firstObject];
            [self updateInterface];
            
            alertView = [[UIAlertView alloc] initWithTitle:@"INFO"
                                                   message:@"Your last cup has been cancelled successfully!"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK",nil];
            alertView.tag = 1;
            [alertView show];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerCallback) userInfo:nil repeats:NO];
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to execute DELETE /api/cups - %@", [error localizedDescription]);
        }];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to post the cup: %@", [error localizedDescription]);
        alertView = [[UIAlertView alloc] initWithTitle:@"PROBLEM"
                                               message:@"Sorry, it's tool late to cancel your last cup :("
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"OK",nil];
        alertView.tag = 1;
        [alertView show];
    }];

    /*
    KKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.objectManager deleteObject:nil path:[NSString stringWithFormat:@"/api/users/%@/last_cup", currentUser.userId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        alertView = [[UIAlertView alloc] initWithTitle:@"INFO"
                                               message:@"Your last cup has been cancelled successfully!"
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"OK",nil];
        alertView.tag = 1;
        [alertView show];

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        alertView = [[UIAlertView alloc] initWithTitle:@"PROBLEM"
                                               message:@"Sorry, it's tool late to cancel your last cup :("
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"OK",nil];
        alertView.tag = 1;
        [alertView show];

    }];
    */
}

- (void)alertView:(UIAlertView *)alertView1 didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertView::didDismissWithButtonIndex()");
    if (alertView1.tag == 0) {
        if (timer != nil && [timer isValid]) {
            NSLog(@"Invalidate timer!");
            [timer invalidate];
        } else {
            NSLog(@"No timer, performing back() after delay...");
            [self performSelector:@selector(goBack) withObject:nil afterDelay:1.5];
            backSelectorScheduled = YES;
        }        
    }
}

@end
