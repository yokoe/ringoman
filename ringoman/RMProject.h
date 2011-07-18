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
    BOOL createHTML;
    BOOL mergeCategories;
}
@property (readonly) NSMutableArray* files;
@property (retain) NSString* projectCompany;
@property (retain) NSString* projectName;
@property (assign) BOOL createHTML;
@property (assign) BOOL mergeCategories;

- (void)addSourceFile:(NSString*)filename;
- (void)removeSourceFileAtIndexes:(NSIndexSet*)indexes;

- (BOOL)loadFromDictionary:(NSDictionary*)dictionary;
- (BOOL)loadFromFile:(NSString*)filename;
- (BOOL)writeToFile:(NSString*)filename;

- (NSDictionary*)dictionaryRepresentation;

@end
