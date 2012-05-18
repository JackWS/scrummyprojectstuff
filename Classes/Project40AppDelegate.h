//
//  Project40AppDelegate.h
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on 12/15/2011
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataParser.h"

@class MainViewController;

@interface Project40AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow*				window;
	MainViewController*		mainViewController;
	
	DataParser*				parser;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet MainViewController* mainViewController;
@property (nonatomic, retain) DataParser* parser;

+ (void)showErrorAlert:(NSString*)error delegate:(id)delegate tag:(int)errorTag;

- (void)rotateWindow:(BOOL)portrait;


@end

