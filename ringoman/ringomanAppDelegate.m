//
//  ringomanAppDelegate.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ringomanAppDelegate.h"

#import "AppController.h"

@implementation ringomanAppDelegate

@synthesize appController;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [appController performSelector:@selector(loadPreviousSettings) withObject:nil afterDelay:0.0f];
    [appController performSelector:@selector(initialSetup) withObject:nil afterDelay:0.1f];
}

// This app should terminate after last window closed.
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
