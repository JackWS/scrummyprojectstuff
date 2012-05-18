//
//  Project40AppDelegate.m
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on 12/15/2011
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import "Project40AppDelegate.h"
#import "MainViewController.h"


@implementation Project40AppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize parser;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	// Override point for customization after application launch.
	self.parser = [[DataParser alloc] init];
	[self.parser loadProjects];
	
	[self.window addSubview:mainViewController.view];
	[self.window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[window release];
	[mainViewController release];
	[parser release];
	[super dealloc];
}


+ (void)showErrorAlert:(NSString*)error delegate:(id)delegate tag:(int)errorTag {
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Project40" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	alert.message = error;
	alert.delegate = delegate;
	alert.tag = errorTag;
	[alert show];
	[alert release];
}


- (void)rotateWindow:(BOOL)portrait {
	
	CGFloat angle = portrait ? 0 : -1.57079633;
	CGAffineTransform rotate = CGAffineTransformMakeRotation(angle);
	[self.window setTransform:rotate];
	
	CGRect contentRect = CGRectZero;
	contentRect = portrait ? CGRectMake(0.0, 0.0, 768.0, 1024.0) : CGRectMake(0.0, 0.0, 1024.0, 768.0);
	
	self.window.bounds = contentRect;
	//[self.window setCenter:CGPointMake(160.0, 240.0)];
}


@end
