//
//  RMProject.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RMProject.h"


static NSString* const kFileKeyForFiles = @"files";
static NSString* const kFileKeyForProjectCompany = @"project_company";
static NSString* const kFileKeyForProjectName = @"project_name";
static NSString* const kFileKeyForMergeCategories = @"merge_categories";


@implementation RMProject
@synthesize createHTML, files, mergeCategories, projectCompany, projectName;

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

#pragma mark Load from file

- (BOOL)loadFromDictionary:(NSDictionary*)dictionary {
    if (files) {
        [files release];
        files = nil;
    }
    files = [[NSMutableArray arrayWithArray:[dictionary objectForKey:kFileKeyForFiles]] retain];
    self.projectCompany = [dictionary objectForKey:kFileKeyForProjectCompany];
    self.projectName = [dictionary objectForKey:kFileKeyForProjectName];
    self.mergeCategories = [[dictionary objectForKey:kFileKeyForMergeCategories] boolValue];
    return YES;
}

- (BOOL)loadFromFile:(NSString *)filename {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:filename];
    if (dictionary) {
        [self loadFromDictionary:dictionary];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark Write to file

- (NSDictionary*)dictionaryRepresentation {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:files forKey:kFileKeyForFiles];
    [dictionary setObject:projectCompany forKey:kFileKeyForProjectCompany];
    [dictionary setObject:projectName forKey:kFileKeyForProjectName];
    [dictionary setObject:[NSNumber numberWithBool:mergeCategories] forKey:kFileKeyForMergeCategories];
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
