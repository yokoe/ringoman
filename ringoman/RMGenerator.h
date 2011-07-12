//
//  RMGenerator.h
//  ringoman
//
//  Created by Sota Yokoe on 11/07/13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RMProject;

@interface RMGenerator : NSObject {
@private
    RMProject* project;
    NSString* outputDirectory;
}
+ (RMGenerator*)generateWithProject:(RMProject*)project outputDirectory:(NSString*)outputDirectory;
@end
