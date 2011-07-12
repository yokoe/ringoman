//
//  RMProject.h
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RMProject : NSObject <NSTableViewDataSource> {
@private
    NSMutableArray* files;
}
@property (readonly) NSMutableArray* files;

- (void)addSourceFile:(NSString*)filename;
- (void)removeSourceFileAtIndexes:(NSIndexSet*)indexes;

@end
