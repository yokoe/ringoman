//
//  RMProject.h
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * RMProject class manages source files to generate docs.
 */
@interface RMProject : NSObject <NSTableViewDataSource> {
@private
    NSMutableArray* files;
    NSString* projectCompany;
    NSString* projectName;
}
@property (readonly) NSMutableArray* files;
@property (retain) NSString* projectCompany;
@property (retain) NSString* projectName;

- (void)addSourceFile:(NSString*)filename;
- (void)removeSourceFileAtIndexes:(NSIndexSet*)indexes;

@end
