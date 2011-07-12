//
//  RMGenerator.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RMGenerator.h"

#import "RMProject.h"

@interface RMGenerator()
@property (nonatomic, retain) RMProject* project;
@property (nonatomic, retain) NSString* outputDirectory;
- (void)execute;
@end


@implementation RMGenerator
@synthesize outputDirectory, project;

#pragma mark Private methods

- (void)execute {
    NSLog(@"%@", outputDirectory);
    
    // Copy source files to temp directory.
}

#pragma mark Public methods

+ (RMGenerator*)generateWithProject:(RMProject*)project outputDirectory:(NSString*)outputDirectory {
    RMGenerator* anInstance = [[[RMGenerator alloc] init] autorelease];
    anInstance.project = project;
    anInstance.outputDirectory = outputDirectory;
    [anInstance execute];
    return anInstance;
}

#pragma mark -

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
