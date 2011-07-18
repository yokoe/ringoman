//
//  AppController.h
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RMInitialSetupWindow;
@class RMProject;

@interface AppController : NSObject<NSWindowDelegate> {
@private
    IBOutlet NSButton *mergeCategoriesCheck;
    IBOutlet NSButton *createHTMLCheck;
    IBOutlet NSTextField *projectCompanyText;
    IBOutlet NSTextField *projectNameText;
    IBOutlet NSTableView *sourceFilesTable;
    IBOutlet NSWindow *mainWindow;
    IBOutlet RMInitialSetupWindow *initialSetupWindow;
    IBOutlet RMProject *currentProject;
}
@property (readonly) RMProject* currentProject;
@property (readonly) NSTableView* sourceFilesTable;

- (void)loadPreviousSettings;
@end
