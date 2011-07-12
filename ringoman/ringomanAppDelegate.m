//
//  ringomanAppDelegate.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ringomanAppDelegate.h"

#import "AppController.h"
#import "RMProject.h"

@implementation ringomanAppDelegate

@synthesize appController;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [appController performSelector:@selector(initialSetup) withObject:nil afterDelay:0.1f];
    
    NSArray* sourceFiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"source_files"];
    if (sourceFiles) {
        for (NSString* sourceFile in sourceFiles) {
            [appController.currentProject addSourceFile:sourceFile];
            [appController.sourceFilesTable reloadData];
        }
    }
}

// This app should terminate after last window closed.
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
