//
//  RMProject.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RMProject.h"

#import "NSString+RelativePathExt.h"

static NSString* const kFileKeyForFiles = @"files";
static NSString* const kFileKeyForOutputDirectory = @"output_directory";
static NSString* const kFileKeyForProjectCompany = @"project_company";
static NSString* const kFileKeyForProjectName = @"project_name";
static NSString* const kFileKeyForMergeCategories = @"merge_categories";


@implementation RMProject
@synthesize createHTML, files, mergeCategories, outputDirectory, projectCompany, projectName;

#pragma mark Validation

- (NSString*)errorMessage {
    // Validates presences
    NSDictionary* textFields = [NSDictionary dictionaryWithObjectsAndKeys:@"Output directory", @"outputDirectory", @"Project company", @"projectCompany", @"Project name", @"projectName", nil];
    for (NSString* varName in [textFields allKeys]) {
        NSString* value = [self performSelector:NSSelectorFromString(varName)];
        if (value == nil || [value length] == 0) {
            return [NSString stringWithFormat:@"%@ cannot be nil.", [textFields objectForKey:varName]];
        }
    }
    
    return nil;
}

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

- (BOOL)loadFromDictionary:(NSDictionary*)dictionary withBasePath:(NSString*)basePath{
    if (dictionary == nil) {
        return NO;
    }
    if (files) {
        [files release];
        files = nil;
    }
    
    if (basePath) {
        NSMutableArray *absoluteFilePaths = [NSMutableArray array];
        for (NSString* relativeFilePath in [dictionary objectForKey:kFileKeyForFiles]) {
            [absoluteFilePaths addObject:[relativeFilePath absolutePathStringWithBasePath:basePath]];
        }
        
        files = [absoluteFilePaths retain];
    } else {
        files = [[NSMutableArray arrayWithArray:[dictionary objectForKey:kFileKeyForFiles]] retain];
    }
    
    NSString* outputDirectory_ = [dictionary objectForKey:kFileKeyForOutputDirectory];
    if (outputDirectory_) {
        if (basePath) {
            self.outputDirectory = [outputDirectory_ absolutePathStringWithBasePath:basePath];
        } else {
            self.outputDirectory = outputDirectory_;
        }
    }
    self.projectCompany = [dictionary objectForKey:kFileKeyForProjectCompany];
    self.projectName = [dictionary objectForKey:kFileKeyForProjectName];
    self.mergeCategories = [[dictionary objectForKey:kFileKeyForMergeCategories] boolValue];
    return YES;
}

- (BOOL)loadFromFile:(NSString *)filename {
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:filename];
    if (dictionary) {
        [self loadFromDictionary:dictionary withBasePath:[filename stringByDeletingLastPathComponent]];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark Write to file

- (NSDictionary*)dictionaryRepresentation {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:files forKey:kFileKeyForFiles];
    [dictionary setObject:outputDirectory forKey:kFileKeyForOutputDirectory];
    [dictionary setObject:projectCompany forKey:kFileKeyForProjectCompany];
    [dictionary setObject:projectName forKey:kFileKeyForProjectName];
    [dictionary setObject:[NSNumber numberWithBool:mergeCategories] forKey:kFileKeyForMergeCategories];
    return dictionary;
}

- (BOOL)writeToFile:(NSString*)filename {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryRepresentation]];
    
    // Save paths in relative path.
    NSArray *absoluteFilePaths = [dictionary objectForKey:kFileKeyForFiles];
    NSMutableArray* relativeFilePaths = [NSMutableArray array];
    
    NSString* basePath = [filename stringByDeletingLastPathComponent];
    
    for (NSString* absoluteFilePath in absoluteFilePaths) {
        [relativeFilePaths addObject:[absoluteFilePath relativePathStringWithBasePath:basePath]];
    }
    
    [dictionary setObject:relativeFilePaths forKey:kFileKeyForFiles];
    [dictionary setObject:[[dictionary objectForKey:kFileKeyForOutputDirectory] relativePathStringWithBasePath:basePath] forKey:kFileKeyForOutputDirectory];
    
    return [dictionary writeToFile:filename atomically:YES];
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
    self.outputDirectory = nil;
    self.projectCompany = nil;
    self.projectName = nil;
    [files release];
    [super dealloc];
}

@end
