//
//  LSNSURLSessionHook.m
//  Nocilla
//
//  Created by Luis Solano Bonet on 08/01/14.
//  Copyright (c) 2014 Luis Solano Bonet. All rights reserved.
//

#import "LSNSURLSessionHook.h"
#import "LSHTTPStubURLProtocol.h"
#import <objc/runtime.h>

@implementation LSNSURLSessionHook

- (void)load {
    [self swizzleClassSelector:@selector(defaultSessionConfiguration) fromClass:[NSURLSessionConfiguration class] toClass:[self class]];
    [self swizzleClassSelector:@selector(backgroundSessionConfiguration:) fromClass:[NSURLSessionConfiguration class] toClass:[self class]];
    [self swizzleClassSelector:@selector(ephemeralSessionConfiguration) fromClass:[NSURLSessionConfiguration class] toClass:[self class]];
}

- (void)unload {
    [self swizzleClassSelector:@selector(defaultSessionConfiguration) fromClass:[NSURLSessionConfiguration class] toClass:[self class]];
    [self swizzleClassSelector:@selector(backgroundSessionConfiguration:) fromClass:[NSURLSessionConfiguration class] toClass:[self class]];
    [self swizzleClassSelector:@selector(ephemeralSessionConfiguration) fromClass:[NSURLSessionConfiguration class] toClass:[self class]];
}

- (void)swizzleClassSelector:(SEL)selector fromClass:(Class)original toClass:(Class)stub {
    
    Method originalMethod = class_getClassMethod(original, selector);
    Method stubMethod = class_getClassMethod(stub, selector);
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NSURLSession hook."];
    }
    method_exchangeImplementations(originalMethod, stubMethod);
    
}

+ (NSURLSessionConfiguration *)defaultSessionConfiguration {
    NSURLSessionConfiguration *config = [LSNSURLSessionHook defaultSessionConfiguration];
    config.protocolClasses = @[[LSHTTPStubURLProtocol class]];
    return config;
}

+ (NSURLSessionConfiguration *)backgroundSessionConfiguration:(NSString *)identifier {
    NSURLSessionConfiguration *config = [LSNSURLSessionHook backgroundSessionConfiguration:identifier];
    config.protocolClasses = @[[LSHTTPStubURLProtocol class]];
    return config;
}

+ (NSURLSessionConfiguration *)ephemeralSessionConfiguration {
    NSURLSessionConfiguration *config = [LSNSURLSessionHook ephemeralSessionConfiguration];
    config.protocolClasses = @[[LSHTTPStubURLProtocol class]];
    return config;
}


@end
