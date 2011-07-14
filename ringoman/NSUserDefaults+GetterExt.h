//
//  NSDictionary+GetterExt.h
//  ringoman
//
//  Created by Sota Yokoe on 11/07/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSUserDefaults (GetterExt)
- (NSString*)stringValueForKey:(NSString*)key defaultValue:(NSString*)defaultValue;
@end
