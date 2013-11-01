//
//  KKAppDelegate.m
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/19/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import "KKAppDelegate.h"
#import "Globals.h"
#import "Reachability.h"
#import "KKUser.h"
#import "KKCup.h"


@interface KKAppDelegate ()
-(void)reachabilityChanged:(NSNotification*)note;
@end

@implementation KKAppDelegate

@synthesize objectManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register default settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:kkBaseURL
                                                            forKey:@"baseurl_preference"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];

    // Setup RestKit stuff
    NSString *baseURL = [defaults stringForKey:@"baseurl_preference"];
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);

    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[KKUser class]];
    [userMapping addAttributeMappingsFromDictionary:@{
        @"_id": @"userId",
        @"name": @"name",
        @"email": @"email",
        @"img": @"thumbnailFilename",
        @"balance": @"balance",
        @"totalCups": @"totalCups"
    }];
    RKResponseDescriptor *userDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"/api/users" keyPath:nil statusCodes:statusCodes];
    RKResponseDescriptor *singleUserDescritpor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping pathPattern:@"/api/users/:userId" keyPath:nil statusCodes:statusCodes];
    
    RKObjectMapping *userRequestMapping = [RKObjectMapping requestMapping];
    [userRequestMapping addAttributeMappingsFromArray:@[ @"name", @"email" ]];
    RKRequestDescriptor *userRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userRequestMapping objectClass:[KKUser class] rootKeyPath:nil];
    
    RKObjectMapping *cupRequestMapping = [RKObjectMapping requestMapping];
    [cupRequestMapping addAttributeMappingsFromArray:@[ @"userId" ]];
    RKRequestDescriptor *cupRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:cupRequestMapping objectClass:[KKCup class] rootKeyPath:nil];

    objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseURL]];
    [objectManager addRequestDescriptorsFromArray:@[ userRequestDescriptor, cupRequestDescriptor ]];
    [objectManager addResponseDescriptorsFromArray:@[ userDescriptor, singleUserDescritpor ]];
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[KKUser class]
                                                        pathPattern:@"/api/users/:userId" method:RKRequestMethodGET]];

    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (KKAppDelegate *)appDelegate {
    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark Private Methods

-(void)reachabilityChanged:(NSNotification*)note {
    NSLog(@"reachabilityChanged: %@", note);
}

@end
