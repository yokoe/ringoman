//
//  NSDictionary+GetterExt.m
//  ringoman
//
//  Created by Sota Yokoe on 11/07/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSUserDefaults+GetterExt.h"


@implementation NSUserDefaults (GetterExt)

- (NSString*)stringValueForKey:(NSString*)key defaultValue:(NSString*)defaultValue {
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return obj;
    } else {
        return defaultValue;
    }
}

@end
