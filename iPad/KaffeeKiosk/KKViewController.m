//
//  KKViewController.m
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/2/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import "KKViewController.h"
#import "KKAppDelegate.h"
#import "KKUser.h"
#import "KKAppDelegate.h"

@interface KKViewController ()
- (void)reloadUsers;
@end

NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id

@implementation KKViewController

@synthesize users;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lastUsedFilter = 0;
    [self reloadUsers];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)reloadUsers
{
    NSLog(@"KKViewController::reloadUsers()");
    KKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.objectManager getObjectsAtPath:@"/api/users" parameters:@{ @"filter":[NSNumber numberWithInt:lastUsedFilter] } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        users = [mappingResult array];
        NSLog(@"KKViewController::reloadUsers(): received users: %i", [users count]);
        [self.collectionView reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error loading users: %@", [error localizedDescription]);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    NSLog(@"KKViewController: number of items: %i", [users count]);
    return [users count];
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    KKCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    [cell setDelegate:self];
    
    KKUser *user = [users objectAtIndex:indexPath.row];
    [cell setUser:user];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [defaults stringForKey:@"baseurl_preference"];

    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/img/%@", baseURL, user.thumbnailFilename]];
    [cell.image setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"User.png"]];
    
    [cell.label setText:user.name];
    [cell.labelEURO setText:[user formattedBalance]];
    if ([user.balance floatValue] <= 0) {
        [cell.labelEURO setTextColor:[UIColor redColor]];
    } else {
        [cell.labelEURO setTextColor:[UIColor blackColor]];
    }
    [cell.labelCups setText:[NSString stringWithFormat:@"%i", [user.totalCups integerValue]]];
    
    return cell;
}

// the user tapped a collection item, load and set the image on the detail view controller
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"KKViewController::prepareForSegue() %@", [segue identifier]);
}

- (void)reloadUsersWithFilter:(NSInteger)filterNumber
{
    if (filterNumber >= 0) {
        lastUsedFilter = filterNumber;
    }
    [self reloadUsers];
}

- (void)isSelectedKKCell:(KKCell *)kkCell
{
    NSLog(@"KKViewController::isSelectedKKCell()");
    
    KKAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UINavigationController *navigationController = (UINavigationController *)appDelegate.window.rootViewController;
    [[navigationController.childViewControllers objectAtIndex:0] performSegueWithIdentifier:@"DetailView" sender:kkCell];
}

@end
