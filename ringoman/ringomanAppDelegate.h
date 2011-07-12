//
//  ringomanAppDelegate.h
//  ringoman
//
//  Created by 横江 宗太 on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AppController;

@interface ringomanAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    AppController *appController;
}
@property (assign) IBOutlet AppController *appController;
@property (assign) IBOutlet NSWindow *window;

@end
