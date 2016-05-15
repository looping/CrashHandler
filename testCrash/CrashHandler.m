//
//  CrashHandler.m
//  testCrash
//
//  Created by Looping on 5/15/16.
//  Copyright © 2016 RidgeCorn. All rights reserved.
//

#import "CrashHandler.h"

@implementation CrashHandler

+ (void)addCrashLog:(NSString *)log {
    NSLog(@"%@\n%@", log, [NSThread callStackSymbols]);
}

@end
