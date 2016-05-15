//
//  NSObject+SafeAccess.m
//  testCrash
//
//  Created by Looping on 5/15/16.
//  Copyright © 2016 RidgeCorn. All rights reserved.
//

#import "NSObject+SafeAccess.h"
#import <objc/runtime.h>
#import "CrashHandler.h"

@implementation NSObject (Swizzle)

+ (BOOL)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    if (!originalMethod) {
        return NO;
    }
    
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (!swizzledMethod) {
        return NO;
    }
    
    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

@end

@implementation NSObject (SafeAccess)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [[self class] instanceMethodSignatureForSelector:@selector(safe_doesNotRecognizeSelector:)];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [self safe_doesNotRecognizeSelector:anInvocation];
}
#pragma clang diagnostic pop

- (void)safe_doesNotRecognizeSelector:(NSInvocation *)anInvocation {
    [CrashHandler addCrashLog:[NSString stringWithFormat:@"CrashError: 大哥，'%@'的'%@' 方法没实现啊，要是没有我，应用就要疯溃了啊！！！",anInvocation.target, NSStringFromSelector(anInvocation.selector)]];
}

@end

@implementation NSArray (SafeAccess)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex0:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex1:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex2:)];
        };
    });
}

- (id)safe_objectAtIndex0:(NSUInteger)index {
    if (self.count >= 1 && self.count > index) {
        return [self safe_objectAtIndex0:index];
    }
    
    [CrashHandler addCrashLog:[NSString stringWithFormat:@"CrashError: 哪个挫逼想要访问数组 %@ 的第 %@ 个元素？", self, @(index)]];
    
    return nil;
}

- (id)safe_objectAtIndex1:(NSUInteger)index {
    if (self.count >= 1 && self.count > index) {
        return [self safe_objectAtIndex1:index];
    }
    
    [CrashHandler addCrashLog:[NSString stringWithFormat:@"CrashError: 哪个挫逼想要访问数组 %@ 的第 %@ 个元素？", self, @(index)]];
    
    return nil;
}

- (id)safe_objectAtIndex2:(NSUInteger)index {
    if (self.count >= 1 && self.count > index) {
        return [self safe_objectAtIndex2:index];
    }
    
    [CrashHandler addCrashLog:[NSString stringWithFormat:@"CrashError: 哪个挫逼想要访问数组 %@ 的第 %@ 个元素？", self, @(index)]];
    
    return nil;
}

@end

@implementation NSMutableArray (SafeAccess)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safe_insertObject:atIndex:)];
        };
    });
}


- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (self.count >= index && anObject != nil) {
        [self safe_insertObject:anObject atIndex:index];
    } else {
        [CrashHandler addCrashLog:[NSString stringWithFormat:@"CrashError: 哪个挫逼想要添加 '%@' 到数组 %@ 的第 %@ 个位置上？", anObject, self, @(index)]];
    }
}

@end

@implementation NSMutableDictionary (SafeAccess)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(safe_setObject:forKey:)];
        };
    });
}

- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject != nil && aKey != nil) {
        [self safe_setObject:anObject forKey:aKey];
    } else {
        [CrashHandler addCrashLog:[NSString stringWithFormat:@"CrashError: 哪个挫逼想要设置键 '%@' 值 '%@' 到字典 %@ 里？", aKey, anObject, self]];
    }
}

@end
