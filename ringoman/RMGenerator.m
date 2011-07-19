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
- (NSString*)copySourceFilesToTemporaryDirectory;
- (void)execute;
@end


@implementation RMGenerator
@synthesize outputDirectory, project;

#pragma mark Private methods

- (NSString*)copySourceFilesToTemporaryDirectory {
    NSString* tmpDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ringoman/sources"];
    NSError* error = nil;
    
    // Remove temp directory if exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpDirectory]) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpDirectory error:&error];
        if (error) {
            NSLog(@"Error at removing temp directory. %@", error);
            return nil;
        }
    }
    
    // Create tmp directory
    [[NSFileManager defaultManager] createDirectoryAtPath:tmpDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"Error at copying source files. %@", error);
        return nil;
    }
    
    // Copy source files
    for (NSString* filepath in project.files) {
        NSString* filename = [filepath lastPathComponent];
        [[NSFileManager defaultManager] copyItemAtPath:filepath toPath:[tmpDirectory stringByAppendingPathComponent:filename] error:&error];
        if (error) {
            NSLog(@"Warning: File copying error at %@, %@", filename, error);
        }
    }
    
    NSLog(@"copied to %@", tmpDirectory);
    
    return tmpDirectory;
}

- (void)runCommandWithCopiedDirectory:(NSString*)copiedDirectory {
    
    NSString* pathForBinary = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingKeyAppledocBinPath];
    NSString* pathForTemplate = [[NSUserDefaults standardUserDefaults] objectForKey:kSettingKeyTemplateDirectoryPath];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:pathForBinary];
    
    NSMutableArray* arguments = [NSMutableArray array];
    
    [arguments addObject:@"--project-name"];
    [arguments addObject:project.projectName];
    
    [arguments addObject:@"--project-company"];
    [arguments addObject:project.projectCompany];
    
    if (project.createHTML) {
        [arguments addObject:@"--create-html"];
    }
    if (project.mergeCategories) {
        [arguments addObject:@"--merge-categories"];
    }
    
    if (pathForTemplate) {
        [arguments addObject:@"--templates"];
        [arguments addObject:pathForTemplate];
    }
    
    // Output directory
    [arguments addObject:@"--output"];
    [arguments addObject:outputDirectory];
    
    [arguments addObject:copiedDirectory]; // Source files directory at last.
    
    NSLog(@"%@", [arguments componentsJoinedByString:@" "]);
    
    [task setArguments:arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *string = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    [task release];
    
    NSLog(@"%@", string);
}

- (void)execute {
    NSLog(@"%@", outputDirectory);
    
    NSString* copiedDirectory = [self copySourceFilesToTemporaryDirectory];
    if (copiedDirectory == nil) {
        NSLog(@"Failed to copy source files.");
        return;
    }
    
    [self runCommandWithCopiedDirectory:copiedDirectory];
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
