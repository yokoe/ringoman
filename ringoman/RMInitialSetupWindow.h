//
//  RMInitialSetupWindow.h
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RMInitialSetupWindow : NSWindow {
@private
    IBOutlet NSTextField *pathLabel;
}
@property (readonly) NSTextField *pathLabel;
@end
