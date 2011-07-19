//
//  ringomanTests.m
//  ringomanTests
//
//  Created by 横江 宗太 on 11/07/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ringomanTests.h"
#import "NSString+RelativePathExt.h"

@implementation ringomanTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)absolutePathTestWithTargetPath:(NSString*)targetPath basePath:(NSString*)basePath expectedAbsolutePath:(NSString*)expectedAbsolutePath {
    NSString* absolutePath = [targetPath absolutePathStringWithBasePath:basePath];
    STAssertTrue([absolutePath isEqualToString:expectedAbsolutePath], @"Absolute path should be %@ but %@",expectedAbsolutePath, absolutePath);
}

- (void)relativePathTestWithTargetPath:(NSString*)targetPath basePath:(NSString*)basePath expectedRelativePath:(NSString*)expectedRelativePath {
    NSString* relativePath = [targetPath relativePathStringWithBasePath:basePath];
    STAssertTrue([relativePath isEqualToString:expectedRelativePath], @"Relative path should be %@ but %@",expectedRelativePath, relativePath);
}

- (void)testAbsolutePath
{
    [self absolutePathTestWithTargetPath:@"test.txt" basePath:@"/Users/foo" expectedAbsolutePath:@"/Users/foo/test.txt"];
    [self absolutePathTestWithTargetPath:@"../test.txt" basePath:@"/Users/foo/bar" expectedAbsolutePath:@"/Users/foo/test.txt"];
}

- (void)testRelativePath
{
    [self relativePathTestWithTargetPath:@"/Users/foo/test.txt" basePath:@"/Users/foo" expectedRelativePath:@"test.txt"];
    [self relativePathTestWithTargetPath:@"/Users/foo/test.txt" basePath:@"/Users" expectedRelativePath:@"foo/test.txt"];
    [self relativePathTestWithTargetPath:@"/Users/foo/test.txt" basePath:@"/Users/bar" expectedRelativePath:@"../foo/test.txt"];
    
}

@end
