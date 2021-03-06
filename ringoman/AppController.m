//
//  AppController.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

#import "RMGenerator.h"
#import "RMInitialSetupWindow.h"
#import "RMProject.h"


@implementation AppController
@synthesize currentProject, sourceFilesTable;

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

- (void)setValuesToUIFields {
#define RMSetStringValueToTextField(control, value) (([control setStringValue:value ? value : @""]))
    RMSetStringValueToTextField(outputDirectoryText, currentProject.outputDirectory);
    RMSetStringValueToTextField(projectCompanyText, currentProject.projectCompany);
    RMSetStringValueToTextField(projectNameText, currentProject.projectName);
    [mergeCategoriesCheck setState:currentProject.mergeCategories];
    [sourceFilesTable reloadData];
#undef RMSetStringValueToTextField
}

- (void)setValuesToProject {
#define RMCheckboxState(control) (([control state] == NSOnState))
    currentProject.outputDirectory = [outputDirectoryText stringValue];
    currentProject.projectCompany = [projectCompanyText stringValue];
    currentProject.projectName = [projectNameText stringValue];
    currentProject.createHTML = RMCheckboxState(createHTMLCheck);
    currentProject.mergeCategories = RMCheckboxState(mergeCategoriesCheck);
#undef RMCheckboxState
}

#pragma mark Load and Save project

- (IBAction)openProject:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:kRMProjectFileExtenstion]];
    [openPanel beginSheetModalForWindow:mainWindow completionHandler:^(NSInteger result) {
        if ([currentProject loadFromFile:[openPanel filename]]) {
            [self setValuesToUIFields];
        } else {
            NSLog(@"Failed to load project.");
        }
    }];
}
- (IBAction)saveAsNewProject:(id)sender {
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:kRMProjectFileExtenstion]];
    [savePanel beginSheetModalForWindow:mainWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [self setValuesToProject];
            if (![currentProject writeToFile:[savePanel filename]]) {
                NSLog(@"Failed to save project.");
            }
        }
    }];
}

#pragma mark Load and save settings

- (void)loadPreviousSettings {
    NSArray* sourceFiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"source_files"];
    if (sourceFiles) {
        for (NSString* sourceFile in sourceFiles) {
            [currentProject addSourceFile:sourceFile];
        }
    }
    [currentProject loadFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"previous_project_settings"] withBasePath:nil];
    [self setValuesToUIFields];
}

- (void)saveCurrentSettings {
    [[NSUserDefaults standardUserDefaults] setObject:[currentProject dictionaryRepresentation] forKey:@"previous_project_settings"];
}

#pragma mark Initial setup
- (IBAction)openPreferences:(id)sender {
    NSString* pathForBinary = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingKeyAppledocBinPath];
    if (pathForBinary) {
        [initialSetupWindow.pathLabel setStringValue:pathForBinary];
    }
    [NSApp beginSheet:initialSetupWindow modalForWindow:mainWindow modalDelegate:self didEndSelector:@selector(initialSheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)initialSetup {
    // Open preferences when path for binary is nil.
    NSString* pathForBinary = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingKeyAppledocBinPath];
    if (pathForBinary == nil) {
        [self openPreferences:nil];
    }
}

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

#pragma mark Source file list

- (void)addSourceFilesRecursively:(NSArray*)filenames {
    NSArray *allowedFileExtensions = [NSArray arrayWithObjects:@"h", @"m", @"mm", nil];
    for (NSString* filename in filenames) {
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory]) {
            if (isDirectory) {
                NSError* error = nil;
                NSArray* filesInDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filename error:&error];
                if (filesInDirectory && error == nil) {
                    NSMutableArray* fullFilenamesInDirectory = [NSMutableArray array];
                    for (NSString* fileInDirectory in filesInDirectory) {
                        [fullFilenamesInDirectory addObject:[filename stringByAppendingPathComponent:fileInDirectory]];
                    }
                    [self addSourceFilesRecursively:fullFilenamesInDirectory];
                } else {
                    NSLog(@"Error at adding source files. %@", error);
                }
            } else {
                // Allows .h, .m, .mm files.
                for (NSString* allowedExtension in allowedFileExtensions) {
                    if ([[filename pathExtension] isEqualToString:allowedExtension]) {
                        [currentProject addSourceFile:filename];
                    }
                }
            }
        }
    }
}

- (IBAction)addSourceFiles:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel beginSheetModalForWindow:mainWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [self addSourceFilesRecursively:[openPanel filenames]];
            [sourceFilesTable reloadData];
            
            // For improving development productivity.
            [[NSUserDefaults standardUserDefaults] setObject:currentProject.files forKey:@"source_files"];
        }
    }];
}

- (IBAction)removeSelectedSourceFiles:(id)sender {
    [currentProject removeSourceFileAtIndexes:[sourceFilesTable selectedRowIndexes]];
    [sourceFilesTable deselectAll:nil];
    [sourceFilesTable reloadData];
    
    // For improving development productivity.
    [[NSUserDefaults standardUserDefaults] setObject:currentProject.files forKey:@"source_files"];
}

#pragma mark Generate

- (IBAction)selectOutputDirectory:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanCreateDirectories:YES];
    
    [openPanel beginSheetModalForWindow:mainWindow completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            currentProject.outputDirectory = [openPanel filename];
            [self setValuesToUIFields];
        }
    }];
}
- (IBAction)generateDocuments:(id)sender {
    // Prepare
    [self setValuesToProject];
    
    // Validations
    NSString* pathForBinary = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingKeyAppledocBinPath];
    if (pathForBinary == nil) {
        NSRunAlertPanel(@"Error", @"The path for appledoc binary is not set.", @"OK", nil, nil);
        return;
    }
    
    NSString* errorMessage = [currentProject errorMessage];
    if (errorMessage) {
        NSRunAlertPanel(@"Error", errorMessage, @"OK", nil, nil);
        return;
    }
    if (currentProject.files == nil || [currentProject.files count] == 0) {
        NSRunAlertPanel(@"Error", @"No source files selected.", @"OK", nil, nil);
        return;
    }
    
    [self saveCurrentSettings];
    [RMGenerator generateWithProject:currentProject outputDirectory:currentProject.outputDirectory];
}

#pragma mark Window delegate

- (void)windowDidBecomeMain:(NSNotification *)notification {
    
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
