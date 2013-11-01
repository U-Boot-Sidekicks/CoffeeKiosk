//
//  KKStatsViewController.m
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 6/14/13.
//  Copyright (c) 2013 Fraunhofer FIT. All rights reserved.
//

#import "KKStatsViewController.h"

@interface KKStatsViewController ()

@end

@implementation KKStatsViewController

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *baseURL = [defaults stringForKey:@"baseurl_preference"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Loading...");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Done loading...");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (IBAction)closeStats:(id)sender {
    NSLog(@"Done showing stats!");
    [self dismissModalViewControllerAnimated:YES];
}

@end
