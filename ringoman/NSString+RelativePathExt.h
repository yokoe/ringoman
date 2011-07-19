//
//  RelativePathExt.h
//  ringoman
//
//  Created by Sota Yokoe on 11/07/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RelativePathExt)

- (NSString*)absolutePathStringWithBasePath:(NSString*)basePath;
- (NSString*)relativePathStringWithBasePath:(NSString*)basePath;
@end
