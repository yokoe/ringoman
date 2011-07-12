//
//  AppController.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "RMInitialSetupWindow.h"


static NSString* const kSettingKeyAppledocBinPath = @"appledoc_bin_path";


@implementation AppController

- (void)showAlert:(NSString*)message {
    NSRunAlertPanel(message, nil, @"OK", nil, nil);
}

- (NSString*)fetchVersionOfAppledocWithBinaryPath:(NSString*)binaryPath {
    
    // http://stackoverflow.com/questions/412562/execute-a-terminal-command-from-a-cocoa-app
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:binaryPath];
    [task setArguments: [NSArray arrayWithObject:@"--version"]];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *string = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    [task release];
    
    NSString* firstLine = [[string componentsSeparatedByString:@"\n"] objectAtIndex:0];
    NSArray* nameAndVersion = [firstLine componentsSeparatedByString:@":"];
    if ([firstLine hasPrefix:@"appledoc"] && [nameAndVersion count] >= 2) {
        NSString* version = [nameAndVersion objectAtIndex:1];
        return [version stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        return nil;
    }
}

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
        if (result == NSFileHandlingPanelOKButton) {        
            // Checks if the binary is valid.
            NSString* version = [self fetchVersionOfAppledocWithBinaryPath:[openPanel filename]];
            if (version != nil) { // Valid
                NSString* pathForBinary = [openPanel filename];
                [[NSUserDefaults standardUserDefaults] setObject:pathForBinary forKey:kSettingKeyAppledocBinPath];
                [initialSetupWindow.pathLabel setStringValue:pathForBinary];
            } else { // Invalid
                [self performSelector:@selector(showAlert:) withObject:@"Invalid binary." afterDelay:0.1f];
            }
        }
    }];
}

#pragma mark Window delegate

- (void)windowDidBecomeMain:(NSNotification *)notification {
    // TODO: Check if setting is okay.
    
    NSString* pathForBinary = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingKeyAppledocBinPath];
    if (pathForBinary) {
        [initialSetupWindow.pathLabel setStringValue:pathForBinary];
    }
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
