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
    NSString* outputDirectory;
    NSString* projectCompany;
    NSString* projectName;
    BOOL createHTML;
    BOOL mergeCategories;
}
@property (readonly) NSMutableArray* files;
@property (retain) NSString* outputDirectory;
@property (retain) NSString* projectCompany;
@property (retain) NSString* projectName;
@property (assign) BOOL createHTML;
@property (assign) BOOL mergeCategories;

- (void)addSourceFile:(NSString*)filename;
- (void)removeSourceFileAtIndexes:(NSIndexSet*)indexes;

- (BOOL)loadFromDictionary:(NSDictionary*)dictionary withBasePath:(NSString*)basePath;
- (BOOL)loadFromFile:(NSString*)filename;
- (BOOL)writeToFile:(NSString*)filename;

- (NSDictionary*)dictionaryRepresentation;

/**
 * Validates fields of project. Returns nil if there are no errors. Otherwise, returns an error message.
 *
 * @return A string value that contains descripton
 */
- (NSString*)errorMessage;

@end
