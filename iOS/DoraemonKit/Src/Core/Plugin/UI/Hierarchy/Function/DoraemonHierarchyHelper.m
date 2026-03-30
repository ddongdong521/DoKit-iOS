//
//  DoraemonHierarchyHelper.m
//  DoraemonKit
//
//  Created by lijiahuan on 2019/11/2.
//

#import "DoraemonHierarchyHelper.h"

static DoraemonHierarchyHelper *_instance = nil;

@implementation DoraemonHierarchyHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DoraemonHierarchyHelper alloc] init];
    });
    return _instance;
}

- (NSArray <UIWindow *>*)allWindows {
    return [self allWindowsIgnorePrefix:nil];
}

- (NSArray <UIWindow *>*)allWindowsIgnorePrefix:(NSString *_Nullable)prefix {
    NSMutableArray<UIWindow *> *results = [NSMutableArray array];
    BOOL includeInternalWindows = YES;
    BOOL onlyVisibleWindows = NO;
    SEL allWindowsSelector = NSSelectorFromString(@"allWindowsIncludingInternalWindows:onlyVisibleWindows:");
    NSMethodSignature *methodSignature = [[UIWindow class] methodSignatureForSelector:allWindowsSelector];
    // 部分系统版本已移除该私有类方法；signature 为空时继续 invoke 会崩溃，需走 UIScene 枚举兜底
    if (methodSignature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = [UIWindow class];
        invocation.selector = allWindowsSelector;
        [invocation setArgument:&includeInternalWindows atIndex:2];
        [invocation setArgument:&onlyVisibleWindows atIndex:3];
        [invocation invoke];
        __unsafe_unretained NSArray<UIWindow *> *windows = nil;
        [invocation getReturnValue:&windows];
        if ([windows isKindOfClass:[NSArray class]] && windows.count) {
            [results addObjectsFromArray:windows];
        }
    }
    if (results.count == 0) {
        if (@available(iOS 13.0, *)) {
            for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (![scene isKindOfClass:[UIWindowScene class]]) {
                    continue;
                }
                [results addObjectsFromArray:((UIWindowScene *)scene).windows];
            }
        }
        for (UIWindow *w in [UIApplication sharedApplication].windows) {
            if (![results containsObject:w]) {
                [results addObject:w];
            }
        }
    }
    
    [results sortUsingComparator:^NSComparisonResult(UIWindow * obj1, UIWindow * obj2) {
        return obj1.windowLevel > obj2.windowLevel;
    }];
    NSMutableArray *removeResults = [[NSMutableArray alloc] init];
    if ([prefix length] > 0) {
        for (UIWindow *window in results) {
            if ([NSStringFromClass(window.class) hasPrefix:prefix]) {
                [removeResults addObject:window];
            }            
        }
    }
    [results removeObjectsInArray:removeResults];
    
    return [NSArray arrayWithArray:results];
}

@end
