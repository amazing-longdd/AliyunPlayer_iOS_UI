//
//  AliyunPVUtil.h
//  AliyunVodPlayerViewSDK
//
//  Created by SMY on 16/9/8.
//  Copyright © 2016年 SMY. All rights reserved.
//  播放器工具类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AliyunVodPlayerViewDefine.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]/// rgb颜色转换（16进制->10进制）
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/*
 *功能：错误提示内容，显示在界面中间的错误内容；用于用户自定义错误
 *备注：请勿更改宏名！请勿更改宏名！请勿更改宏名！
 */
static NSString *  ALIYUNVODVIEW_PLAYFINISH ;//= @"Watch again, please click replay";
static NSString *  ALIYUNVODVIEW_NETWORKTIMEOUT;// = @"The current network is not good. Please click replay later";
static NSString *  ALIYUNVODVIEW_NETWORKUNREACHABLE ;//= @"No network connection, check the network, click replay";
static NSString *  ALIYUNVODVIEW_LOADINGDATAERROR ;//= @"Video loading error, please click replay";
static NSString *  ALIYUNVODVIEW_USEMOBILENETWORK ;//= @"For mobile networks, click play";

@interface AliyunUtil : NSObject

//version
+ (NSString*)getSDKVersion;

//图片库bundle
+ (NSBundle *)resourceBundle;

//语言库bundle
+ (NSBundle *)languageBundle;

//从图片库获取图片
+ (UIImage *)imageWithNameInBundle:(NSString *)nameInBundle;

//根据皮肤颜色获取图片
+ (UIImage *)imageWithNameInBundle:(NSString *)name skin:(AliyunVodPlayerViewSkin)skin;

//是否手机状态条处于竖屏状态
+ (BOOL)isInterfaceOrientationPortrait;

//是否全屏
+ (void)setFullOrHalfScreen;

//根据s-》hh:mm:ss
+ (NSString *)timeformatFromSeconds:(NSInteger)seconds;

//绘制
+ (void)drawFillRoundRect:(CGRect)rect radius:(CGFloat)radius color:(UIColor *)color context:(CGContextRef)context;
//皮肤字体颜色
+ (UIColor *)textColor:(AliyunVodPlayerViewSkin)skin;

//根据像素值获取 px/2
+ (float)convertPixelToPoint:(float)pixel;

//定义字体大小，font
+ (float)nomalTextSize;

//获取所有已知清晰度泪飙
+ (NSArray<NSString *> *)allQualities;

//播放完成描述
+ (void)setPlayFinishTips:(NSString *)des;

+ (NSString *)playFinishTips;

//网络超时
+ (void)setNetworkTimeoutTips:(NSString *)des;

+ (NSString *)networkTimeoutTips;

//无网络状态
+ (void)setNetworkUnreachableTips:(NSString *)des;

+ (NSString *)networkUnreachableTips;

//加载数据错误
+ (void)setLoadingDataErrorTips:(NSString *)des;

+ (NSString*)loadingDataErrorTips;

//网络切换
+ (void)setSwitchToMobileNetworkTips:(NSString *)des;

+ (NSString *)switchToMobileNetworkTips;

@end
