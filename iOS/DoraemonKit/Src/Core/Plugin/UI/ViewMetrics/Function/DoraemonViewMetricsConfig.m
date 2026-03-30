//
//  DoraemonViewMetricsManager.m
//  DoraemonKit
//
//  Created by xgb on 2018/12/11.
//

#import "DoraemonViewMetricsConfig.h"
#import "UIView+DoraemonViewMetrics.h"

@implementation DoraemonViewMetricsConfig

+ (instancetype)defaultConfig
{
    static DoraemonViewMetricsConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DoraemonViewMetricsConfig new];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borderWidth = 1;
        //self.enable = NO;
    }
    return self;
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    // UIScene：仅枚举 .windows 会漏掉仅挂在 scene 上的窗口；与层级调试等逻辑保持一致
    NSMutableArray<UIWindow *> *all = [NSMutableArray array];
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }
            [all addObjectsFromArray:((UIWindowScene *)scene).windows];
        }
    }
    for (UIWindow *w in [UIApplication sharedApplication].windows) {
        if (![all containsObject:w]) {
            [all addObject:w];
        }
    }
    for (UIWindow *window in all) {
        [window doraemonMetricsRecursiveEnable:enable];
    }
}

@end
