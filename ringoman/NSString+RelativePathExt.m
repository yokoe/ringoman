//
//  RelativePathExt.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+RelativePathExt.h"

@implementation NSString (RelativePathExt)

- (NSString*)absolutePathStringWithBasePath:(NSString*)basePath {
    NSMutableArray* targetPathComponents = [NSMutableArray arrayWithArray:[self pathComponents]];
    NSMutableArray* basePathComponents = [NSMutableArray arrayWithArray:[basePath pathComponents]];
    
    for (NSString* pathComponent in targetPathComponents) {
        if ([pathComponent isEqualToString:@".."]) {
            [basePathComponents removeLastObject];
        } else {
            [basePathComponents addObject:pathComponent];
        }
    }
    
    return [[basePathComponents componentsJoinedByString:@"/"] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
}

- (NSString*)relativePathStringWithBasePath:(NSString*)basePath {
    NSMutableArray* targetPathComponents = [NSMutableArray arrayWithArray:[self pathComponents]];
    NSMutableArray* basePathComponents = [NSMutableArray arrayWithArray:[basePath pathComponents]];
    
    while ([targetPathComponents count] * [basePathComponents count] > 0) {
        NSString* firstTargetPathComponent = [targetPathComponents objectAtIndex:0];
        NSString* firstBasePathComponent = [basePathComponents objectAtIndex:0];
        if (![firstTargetPathComponent isEqualToString:firstBasePathComponent]) {
            break;
        }
        [targetPathComponents removeObjectAtIndex:0];
        [basePathComponents removeObjectAtIndex:0];
    }
    
    for (NSString* basePathComponent in basePathComponents) {
        [targetPathComponents insertObject:@".." atIndex:0];
    }
    
    return [targetPathComponents componentsJoinedByString:@"/"];
}
@end
