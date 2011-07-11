//
//  AppController.h
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RMInitialSetupWindow;

@interface AppController : NSObject<NSWindowDelegate> {
@private
    IBOutlet NSWindow *mainWindow;
    IBOutlet RMInitialSetupWindow *initialSetupWindow;
}

@end
