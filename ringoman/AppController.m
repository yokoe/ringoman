//
//  AppController.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "RMInitialSetupWindow.h"


@implementation AppController

#pragma mark Initial setup

- (void)initialSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [sheet close];
}
- (IBAction)finishInitialSetup:(id)sender {
    [NSApp endSheet:initialSetupWindow];
}
- (IBAction)openSheetForChoosingAppledocBinary:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@""]];
    [openPanel beginSheetModalForWindow:initialSetupWindow completionHandler:^(NSInteger result) {
        [initialSetupWindow.pathLabel setStringValue:[openPanel filename]];
    }];
}

#pragma mark Window delegate

- (void)windowDidBecomeMain:(NSNotification *)notification {
    // TODO: Check if setting is okay.
    
    [NSApp beginSheet:initialSetupWindow modalForWindow:mainWindow modalDelegate:self didEndSelector:@selector(initialSheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

#pragma mark - 

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
