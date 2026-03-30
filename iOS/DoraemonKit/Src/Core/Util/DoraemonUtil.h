//
//  DoraemonUtil.h
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//  Copyright © 2017年 yixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DoraemonUtil : NSObject

@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, strong) NSMutableArray *bigFileArray;

+ (NSString *)dateFormatTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)dateFormatNSDate:(NSDate *)date;

+ (NSString *)dateFormatNow;

// byte格式化为 B KB MB 方便流量查看
+ (NSString *)formatByte:(CGFloat)byte;

+ (void)savePerformanceDataInFile:(NSString *)fileName data:(NSString *)data;

+ (NSString *)dictToJsonStr:(NSDictionary *)dict;

+ (NSString *)arrayToJsonStr:(NSArray *)array;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;

+ (NSString *)formatTimeIntervalToMS:(NSTimeInterval)timeInterval;

+ (NSString *)currentTimeInterval;

//获取某一条文件路径的文件大小
- (void)getFileSizeWithPath:(NSString *)path;

- (NSArray *)getBigSizeFileFormPath:(NSString *)path;

//删除某一路径下的所有文件
+ (void)clearFileWithPath:(NSString *)path;

+ (void)clearLocalDatas;

+ (void)shareText:(NSString *)text formVC:(UIViewController *)vc;//share text
+ (void)shareImage:(UIImage *)image formVC:(UIViewController *)vc;//share image
+ (void)shareURL:(NSURL *)url formVC:(UIViewController *)vc;//share url

+ (void)openAppSetting;

+ (UIWindow *)getKeyWindow;

/// 组件检查/对齐/取色等浮层须挂在业务宿主 window；当前 keyWindow 常为 DoKit 工具窗时，getKeyWindow 会得到错误目标。
+ (nullable UIWindow *)hostKeyWindowForAppOverlay;

/// UIScene 下 AppDelegate.window 常为 nil；离开 DoKit 浮动面板时需把 keyWindow 交还「主应用 window」（优先 UIWindowLevelNormal）
+ (nullable UIWindow *)mainWindowToRestoreKeyWindow;

+ (NSArray *)getWebViews;

+ (void)openPlugin:(UIViewController *)vc __attribute__((deprecated("此方法已弃用,请使用[DoraemonHomeWindow openPlugin:vc];")));

+ (UIViewController *)rootViewControllerForKeyWindow __attribute__((deprecated("此方法已弃用,请使用[UIViewController rootViewControllerForKeyWindow]")));

+ (UIViewController *)topViewControllerForKeyWindow __attribute__((deprecated("此方法已弃用,请使用[UIViewController topViewControllerForKeyWindow]")));
@end
