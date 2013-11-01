//
//  KKNewUserViewController.m
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/10/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import "KKNewUserViewController.h"
#import "KKAppDelegate.h"
#import "KKUser.h"

@interface KKNewUserViewController ()

@end

@implementation KKNewUserViewController

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
    [self.fullname becomeFirstResponder];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    [self.fullname setText:@""];
    [self.email setText:@""];
}

- (IBAction)cancel:(id)sender {
    [self.fullname resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    KKAppDelegate  *appDelegate = [[UIApplication sharedApplication] delegate];
    
    KKUser *user = [KKUser new];
    user.name = [self.fullname text];
    user.email = [self.email text];
    
    if (![user isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"Name and email fields are both mandatory!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    [appDelegate.objectManager postObject:user path:@"/api/users" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.callingViewController refreshTapped:nil];
        }];

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to create a user: %@", [error userInfo]);
    }];
}


@end
