//
//  KKRootViewController.m
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/11/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import "KKRootViewController.h"
#import "KKNewUserViewController.h"
#import "KKDetailViewController.h"

@interface KKRootViewController ()

@end

@implementation KKRootViewController

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
    NSLog(@"KKRootViewController::viewDidLoad");
    [self.navigationController setDelegate:self];
    [self.activityIndicator stopAnimating];
    
    collectionViewController = [[KKViewController alloc] init];
    collectionViewController.collectionView = collectionView;
    collectionView.dataSource = collectionViewController;
    collectionView.delegate = collectionViewController;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueName = segue.identifier;

    NSLog(@"KKRootViewController::prepareForSegue() %@", [segue identifier]);
    
    if ([[segue identifier] isEqualToString:@"DetailView"])
    {
        //NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        //KKUser *selectedUser = [users objectAtIndex:selectedIndexPath.row];
        KKUser *selectedUser = ((KKCell *)sender).user;
        NSLog(@"selectedUser = %@", selectedUser);
        KKDetailViewController *detailViewController = [segue destinationViewController];
        [detailViewController setCurrentUser:selectedUser];
    }
    
    else if ([segueName isEqualToString:@"collectionView"]) {
        collectionViewController = (KKViewController *)[segue destinationViewController];
        if (reloadTimer == nil) {
            reloadTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(refreshTapped:) userInfo:nil repeats:YES];
        }
        
    } else if ([segueName isEqualToString:@"newUser"]) {
        [(KKNewUserViewController *)[segue destinationViewController] setCallingViewController:self];
    }
}

- (IBAction)refreshTapped:(id)sender
{
    [self.activityIndicator startAnimating];
    [collectionViewController reloadUsersWithFilter:self.filterControl.selectedSegmentIndex];
    [self.activityIndicator stopAnimating];
}

- (IBAction)filterSelected:(id)sender
{
    [self refreshTapped:nil];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:self]) {
        [self refreshTapped:nil];
    }
}

@end
