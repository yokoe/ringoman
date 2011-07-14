//
//  RMProject.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RMProject.h"


@implementation RMProject
@synthesize createHTML, files, projectCompany, projectName;

#pragma mark Adding source file

- (void)addSourceFile:(NSString*)filename {
    if (![files containsObject:filename]) {
        [files addObject:filename];
    }
}

#pragma mark Deleting source file

- (void)removeSourceFileAtIndexes:(NSIndexSet *)indexes {
    [files removeObjectsAtIndexes:indexes];
}

#pragma mark Write to file

- (NSDictionary*)dictionaryRepresentation {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:files forKey:@"files"];
    [dictionary setObject:projectCompany forKey:@"project_company"];
    [dictionary setObject:projectName forKey:@"project_name"];
    return dictionary;
}

- (BOOL)writeToFile:(NSString*)filename {
    return [[self dictionaryRepresentation] writeToFile:filename atomically:YES];
}

#pragma mark NSTableViewDataSourceProtocol

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [files count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if (rowIndex < [files count]) {
        return [files objectAtIndex:rowIndex];
    }
    
    // Should not reach here.
    return nil;
}

#pragma mark -

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        files = [[NSMutableArray array] retain];
    }
    
    return self;
}

- (void)dealloc
{
    self.projectCompany = nil;
    self.projectName = nil;
    [files release];
    [super dealloc];
}

@end
